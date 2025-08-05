defmodule TechraffleWeb.UserLive.Registration do
  use TechraffleWeb, :live_view

  alias Techraffle.Accounts
  alias Techraffle.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
      <div class="mx-auto max-w-sm">
        <div class="text-center">
          <.header>
            Regístrate para obtener una cuenta
            <:subtitle>
              ¿Ya estás registrado?
              <.link navigate={~p"/users/log-in"} class="font-semibold text-brand hover:underline">
                Inicia sesión
              </.link>
              en tu cuenta ahora.
            </:subtitle>
          </.header>
        </div>

        <.simple_form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
          <.input
            field={@form[:username]}
            type="text"
            label="Nombre de usuario"
            autocomplete="username"
            required
          />

          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            autocomplete="email"
            required
          />

          <.input
            field={@form[:password]}
            type="password"
            label="Contraseña"
            autocomplete="new-password"
            required
          />

          <.button phx-disable-with="Creando cuenta..." class="btn btn-primary w-full">
            Crear una cuenta
          </.button>
        </.simple_form>
      </div>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: TechraffleWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
        socket
        |> put_flash(:info, "Cuenta creada correctamente. Ahora puedes iniciar sesión.")
        |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
