defmodule TechraffleWeb.RaffleLive.Index do
  use TechraffleWeb, :live_view

  alias Techraffle.Raffles
  alias Techraffle.Charities
  alias TechraffleWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket = assign(socket, :charity_options, Charities.charity_names_and_slugs())
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    raffles = Raffles.filter_raffles(params)

    socket =
      socket
      |> stream(:raffles, [], reset: true)
      |> stream(:raffles, raffles)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <CustomComponents.banner>
        <.icon name="hero-sparkles-solid"/> TechRaffle
        <:details>
          Participa en sorteos de tecnología y ayuda a ONGs.
        </:details>
      </CustomComponents.banner>

      <.filter_form form={@form} charity_options={@charity_options}/>

      <div class="raffles" id="raffles" phx-update="stream">
        <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id}/>
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter_form" phx-change="filter">
      <.input
        field={@form[:q]}
        placeholder="Buscar..."
        autocomplete="off"
        phx-debounce="500"
      />

      <.input
        type="select"
        field={@form[:status]}
        prompt="Estado"
        options={[
          {"Próximo", :upcoming},
          {"Abierto", :open},
          {"Cerrado", :close}
        ]}
      />

      <.input
        type="select"
        field={@form[:charity]}
        prompt="ONG"
        options={@charity_options}
      />

      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Ordenar por"
        options={[
          {"Premio", "prize"},
          {"Precio: Mayor a menor", "ticket_price_desc"},
          {"Precio: Menor a mayor", "ticket_price_asc"},
          {"ONG", "charity"}
        ]}
      />

      <.link patch={~p"/raffles"}>
        Restablecer
      </.link>
    </.form>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by charity))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/raffles?#{params}")

    {:noreply, socket}
  end

  attr :raffle, Techraffle.Raffles.Raffle, required: true
  attr :id, :string, required: true
  def raffle_card(assigns) do
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
      <div class="card">
        <div class="charity">
          <%= @raffle.charity.name %>
        </div>
        <img src={@raffle.image_path} />
        <h2><%= @raffle.prize %></h2>
        <div class="details">
          <div class="price">
            <%= @raffle.ticket_price %> € / ticket
          </div>
          <CustomComponents.badge status={@raffle.status}/>
        </div>
      </div>
    </.link>
    """
  end
end
