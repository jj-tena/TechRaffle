defmodule TechraffleWeb.CharityLive.Index do
  use TechraffleWeb, :live_view

  alias Techraffle.Charities

  @impl true
  def render(assigns) do
    ~H"""
      <.header>
        Listado de ONGs
        <:actions>
          <.link navigate={~p"/charities/new"}>
            <.icon name="hero-plus" /> Nueva ONG
          </.link>
        </:actions>
      </.header>

      <.table
        id="charities"
        rows={@streams.charities}
        row_click={fn {_id, charity} -> JS.navigate(~p"/charities/#{charity}") end}
      >
        <:col :let={{_id, charity}} label="Nombre">{charity.name}</:col>
        <:col :let={{_id, charity}} label="Identificador">{charity.slug}</:col>
        <:action :let={{_id, charity}}>
          <div class="sr-only">
            <.link navigate={~p"/charities/#{charity}"}>Ver</.link>
          </div>
          <.link navigate={~p"/charities/#{charity}/edit"}>Editar</.link>
        </:action>
        <:action :let={{id, charity}}>
          <.link
            phx-click={JS.push("delete", value: %{id: charity.id}) |> hide("##{id}")}
            data-confirm="¿Estás seguro?"
          >
            Borrar
          </.link>
        </:action>
      </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listado de ONGs")
     |> stream(:charities, Charities.list_charities())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    charity = Charities.get_charity!(id)
    {:ok, _} = Charities.delete_charity(charity)

    {:noreply, stream_delete(socket, :charities, charity)}
  end
end
