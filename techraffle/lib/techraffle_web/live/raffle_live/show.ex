defmodule TechraffleWeb.RaffleLive.Show do
  use TechraffleWeb, :live_view

  alias Techraffle.Raffles
  alias TechraffleWeb.CustomComponents
  alias Techraffle.Tickets
  alias Techraffle.Tickets.Ticket
  alias TechraffleWeb.Presence

  on_mount {TechraffleWeb.UserAuth, :mount_current_scope}

  def mount(_params, _session, socket) do
    changeset = Tickets.change_ticket(%Ticket{})
    socket = assign(socket, :form, to_form(changeset))
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    user = socket.assigns.current_scope && socket.assigns.current_scope.user

    if connected?(socket) do
      Raffles.subscribe(id)

      if user do
        Presence.track_user(id, user)
        Presence.subscribe(id)
      end
    end

    presences = Presence.list_users(id)
    raffle = Raffles.get_raffle!(id)
    tickets = Raffles.list_tickets(raffle)

    socket =
      socket
      |> assign(:raffle, raffle)
      |> stream(:tickets, tickets)
      |> stream(:presences, presences)
      |> assign(:ticket_count, Enum.count(tickets))
      |> assign(:ticket_sum, tickets |> Enum.map(& &1.price) |> Enum.sum())
      |> assign(:page_title, raffle.prize)
      |> assign_async(:featured_raffles, fn ->
        {:ok, %{featured_raffles: Raffles.featured_raffles(raffle)}}
      end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-show">
      <CustomComponents.banner :if={@raffle.winning_ticket}>
        <.icon name="hero-sparkles-solid"/>
        El ticket #{@raffle.winning_ticket.id} ha ganado el sorteo
        <:details>
          {@raffle.winning_ticket.comment}
        </:details>
      </CustomComponents.banner>

      <div class="raffle">
        <img src={@raffle.image_path} />
        <section>
          <CustomComponents.badge status={@raffle.status} />
          <header>
            <div>
              <h2><%= @raffle.prize %></h2>
              <h3><%= @raffle.charity.name %></h3>
            </div>
            <div class="price">
              <%= @raffle.ticket_price %> €
            </div>
          </header>
          <div class="totals">
            <%= @ticket_count %> Tickets vendidos &bull; <%= @ticket_sum %> € Recaudados
          </div>
          <div class="description">
            <%= @raffle.description %>
          </div>
        </section>
      </div>

      <div class="activity">
        <div class="left">
          <div :if={@raffle.status == :open}>
            <%= if @current_scope && @current_scope.user do %>
              <.form for={@form} id="ticket-form" phx-change="validate" phx-submit="save">
                <.input field={@form[:comment]} placeholder="Comenta..." autofocus/>
                <.button>
                  Comprar ticket
                </.button>
              </.form>
            <% else %>
              <.link href={~p"/users/log-in"} class="button">
                Inicia sesión para comprar un ticket
              </.link>
            <% end %>
          </div>
          <div id="tickets" phx-update="stream">
            <.ticket :for={{dom_id, ticket} <- @streams.tickets}
              ticket={ticket}
              id={dom_id}
            />
          </div>
        </div>

        <div class="right">
          <.featured_raffles raffles={@featured_raffles}/>
          <.raffle_watchers :if={@current_scope && @current_scope.user} presences={@streams.presences}/>
        </div>
      </div>
    </div>
    """
  end

  def raffle_watchers(assigns) do
    ~H"""
    <section>
      <h4>Espectadores</h4>
      <ul class="presences" id="raffle-watchers" phx-update="stream">
        <li :for={{dom_id, %{id: email, metas: metas}} <- @presences} id={dom_id}>
          <.icon name="hero-user-circle-solid" class="w-5 h-5"/>
          <%= email %> (<%= length(metas) %>)
        </li>
      </ul>
    </section>
    """
  end

  def featured_raffles(assigns) do
    ~H"""
    <section>
      <h4>Otros sorteos</h4>
      <.async_result :let={result} assign={@raffles}>
        <:loading>
          <div class="spinner"> </div>
        </:loading>
        <:failed :let={{:error, reason}}>
          <div class="failed">
            Error: <%= reason %>
          </div>
        </:failed>
        <ul class="raffles">
          <li :for={raffle <- result}>
            <.link navigate={~p"/raffles/#{raffle}"}>
              <img src={raffle.image_path} /> <%= raffle.prize %>
            </.link>
          </li>
        </ul>
      </.async_result>
    </section>
    """
  end

  def handle_event("validate", %{"ticket" => ticket_params}, socket) do
    changeset = Tickets.change_ticket(%Ticket{}, ticket_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  def handle_event("save", %{"ticket" => ticket_params}, socket) do
    %{raffle: raffle, current_scope: %{user: user}} = socket.assigns

    case Tickets.create_ticket(raffle, user, ticket_params) do
      {:ok, ticket} ->
        changeset = Tickets.change_ticket(%Ticket{})
        socket =
          socket
          |> assign(:form, to_form(changeset))
          |> stream_insert(:tickets, ticket, at: 0)
          |> update(:ticket_count, &(&1 + 1))
          |> update(:ticket_sum, &(&1 + ticket.price))
        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_info({:ticket_created, ticket}, socket) do
    socket =
      socket
      |> stream_insert(:tickets, ticket, at: 0)
      |> update(:ticket_count, &(&1 + 1))
      |> update(:ticket_sum, &(&1 + ticket.price))
    {:noreply, socket}
  end

  def handle_info({:raffle_updated, raffle}, socket) do
    {:noreply, assign(socket, :raffle, raffle)}
  end

  def handle_info({:user_joined, presence}, socket) do
    {:noreply, stream_insert(socket, :presences, presence)}
  end

  def handle_info({:user_left, presence}, socket) do
    if presence.metas == [] do
      {:noreply, stream_delete(socket, :presences, presence)}
    else
      {:noreply, stream_insert(socket, :presences, presence)}
    end
  end

  attr :id, :string, required: true
  attr :ticket, Ticket, required: true
  def ticket(assigns) do
    ~H"""
    <div class="ticket" id={@id}>
      <span class="timeline"></span>
      <section>
        <div class="price-paid">
          ${@ticket.price}
        </div>
        <div>
          <span class="username">
            {@ticket.user.username}
          </span>
          compró un ticket
          <blockquote>
            {@ticket.comment}
          </blockquote>
        </div>
      </section>
    </div>
    """
  end
end
