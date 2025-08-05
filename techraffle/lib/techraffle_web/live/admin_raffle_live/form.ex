defmodule TechraffleWeb.AdminRaffleLive.Form do
  use TechraffleWeb, :live_view
  alias Techraffle.Admin
  alias Techraffle.Raffles.Raffle
  alias Techraffle.Charities

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:charity_options, Charities.charity_names_and_ids())
      |> apply_action(socket.assigns.live_action, params)

    {:ok, socket}
  end

  defp apply_action(socket, :new, _params) do
    raffle = %Raffle{}

    changeset = Admin.change_raffle(raffle)

    socket
      |> assign(:page_title, "Nuevo sorteo")
      |> assign(:form, to_form(changeset))
      |> assign(:raffle, raffle)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    raffle = Admin.get_raffle!(id)

    changeset = Admin.change_raffle(raffle)

    socket
      |> assign(:page_title, "Editar sorteo")
      |> assign(:form, to_form(changeset))
      |> assign(:raffle, raffle)
  end

  def render(assigns) do
    ~H"""
    <.header>
      <%= @page_title %>
    </.header>
    <.simple_form for={@form} id="raffle-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:prize]} label="Premio"/>

      <.input field={@form[:description]} type="textarea" label="Descripción" phx-debounce="2000"/>

      <.input field={@form[:ticket_price]} type="number" label="Precio del ticket"/>

      <.input
        field={@form[:status]}
        type="select"
        label="Estado"
        prompt="Elige un estado"
        options={[
          {"Próximo", :upcoming},
          {"Abierto", :open},
          {"Cerrado", :close}
        ]}
      />

      <.input
        field={@form[:charity_id]}
        type="select"
        label="ONG"
        prompt="Elige una ONG"
        options={@charity_options}
      />

      <.input field={@form[:image_path]} label="URL de la imagen"/>

      <:actions>
        <.button>Guardar sorteo</.button>
      </:actions>

    </.simple_form>

    <.back navigate={~p"/admin/raffles"}>
      Volver
    </.back>
    """
  end

  def handle_event("save", %{"raffle" => raffle_params}, socket) do
    save_raffle(socket, socket.assigns.live_action, raffle_params)
  end

  def handle_event("validate", %{"raffle" => raffle_params}, socket) do
    changeset = Admin.change_raffle(socket.assigns.raffle, raffle_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  defp save_raffle(socket, :new, raffle_params) do
    case Admin.create_raffle(raffle_params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "¡Sorteo creado correctamente!")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  defp save_raffle(socket, :edit, raffle_params) do
    case Admin.update_raffle(socket.assigns.raffle, raffle_params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "¡Sorteo editado correctamente!")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

end
