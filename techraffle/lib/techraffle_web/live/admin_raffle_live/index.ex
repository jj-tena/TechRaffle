defmodule TechraffleWeb.AdminRaffleLive.Index do
  use TechraffleWeb, :live_view

  alias Techraffle.Admin

  import TechraffleWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listado de sorteos")
      |> stream(:raffles, Admin.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.header>
        <%= @page_title %>
        <:actions>
          <.link navigate={~p"/admin/raffles/new"} class="button">
            Nuevo sorteo
          </.link>
        </:actions>
      </.header>
      <.table
        id="raffles"
        rows={@streams.raffles}
        row_click={fn {_, raffle} -> JS.navigate(~p"/raffles/#{raffle}") end}
      >
        <:col :let={{_dom_id, raffle}} label="Premio">
          <.link navigate={~p"/raffles/#{raffle}"}>
            <%= raffle.prize %>
          </.link>
        </:col>

        <:col :let={{_dom_id, raffle}} label="Estado">
          <.badge status={raffle.status}/>
        </:col>

        <:col :let={{_dom_id, raffle}} label="Precio del ticket">
          <%= raffle.ticket_price %>
        </:col>

        <:col :let={{_dom_id, raffle}} label="Número del ticket ganador">
          <%= raffle.winning_ticket_id %>
        </:col>

        <:action :let={{_dom_id, raffle}}>
          <.link navigate={~p"/admin/raffles/#{raffle}/edit"}>
            Editar
          </.link>
        </:action>

        <:action :let={{dom_id, raffle}}>
          <.link phx-click={delete_and_hide(dom_id, raffle)} data-confirm="¿Estás seguro?">
            Borrar
          </.link>
        </:action>

        <:action :let={{_dom_id, raffle}}>
          <.link phx-click="draw-winner" phx-value-id={raffle.id}>
            Obtener ganador
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Admin.get_raffle!(id)
    {:ok, _} = Admin.delete_raffle(raffle)
    {:noreply, stream_delete(socket, :raffles, raffle)}
  end

  def handle_event("draw-winner", %{"id" => id}, socket) do
    raffle = Admin.get_raffle!(id)
    case Admin.draw_winner(raffle) do
      {:ok, raffle} ->
        socket =
          socket
          |> put_flash(:info, "¡Ticket ganador seleccionado!")
          |> stream_insert(:raffles, raffle)
        {:noreply, socket}
      {:error, error} ->
        {:noreply, put_flash(socket, :error, error)}
    end
  end

  def delete_and_hide(dom_id, raffle) do
    JS.push("delete", value: %{id: raffle.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
