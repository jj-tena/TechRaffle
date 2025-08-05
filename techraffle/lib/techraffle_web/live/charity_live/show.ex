defmodule TechraffleWeb.CharityLive.Show do
  use TechraffleWeb, :live_view

  alias Techraffle.Charities

  @impl true
  def render(assigns) do
    ~H"""
      <.header>
        ONG {@charity.id}
        <:subtitle>Este es un registro de una ONG en tu base de datos.</:subtitle>
        <:actions>
          <.link navigate={~p"/charities"}>
            <.icon name="hero-arrow-left" />
          </.link>
          <.link navigate={~p"/charities/#{@charity}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Editar ONG
          </.link>
        </:actions>
      </.header>

      <.list>
        <:item title="Nombre">{@charity.name}</:item>
        <:item title="Identificador">{@charity.slug}</:item>
      </.list>

      <section class="mt-12">
        <h4>Sorteos</h4>
        <ul class="raffles">
          <li :for={raffle <- @charity.raffles}>
            <.link navigate={~p"/raffles/#{raffle}"}>
              <img src={raffle.image_path} /> <%= raffle.prize %>
            </.link>
          </li>
        </ul>
      </section>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Mostrar ONG")
     |> assign(:charity, Charities.get_charity_with_raffles!(id))}
  end
end
