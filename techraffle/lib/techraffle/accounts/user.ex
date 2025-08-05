defmodule Techraffle.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :is_admin, :boolean, default: false
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime
    field :authenticated_at, :utc_datetime, virtual: true

    has_many :tickets, Techraffle.Tickets.Ticket

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registering or changing the email.

  It requires the email to change otherwise an error is added.

  ## Options

    * `:validate_unique` - Set to false if you don't want to validate the
      uniqueness of the email, useful when displaying live validations.
      Defaults to `true`.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
  end

  defp validate_email(changeset, opts) do
    changeset =
      changeset
      |> validate_required([:email])
      |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/,
        message: "debe contener un signo @ y no debe tener espacios"
      )
      |> validate_length(:email, max: 160, message: "es demasiado largo")

    if Keyword.get(opts, :validate_unique, true) do
      changeset
      |> unsafe_validate_unique(:email, Techraffle.Repo)
      |> unique_constraint(:email, message: "ya está en uso")
      |> validate_email_changed()
    else
      changeset
    end
  end

  defp validate_email_changed(changeset) do
    if get_field(changeset, :email) && get_change(changeset, :email) == nil do
      add_error(changeset, :email, "no ha cambiado")
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the password.

  It is important to validate the length of the password, as long passwords may
  be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "no coincide con la confirmación")
    |> validate_password(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password,
      min: 12,
      max: 72,
      message: "debe tener entre 12 y 72 caracteres"
    )
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:password,
        max: 72,
        count: :bytes,
        message: "es demasiado larga (máx. 72 bytes)"
      )
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username,
      min: 3,
      max: 20,
      message: "debe tener entre 3 y 20 caracteres"
    )
    |> unsafe_validate_unique(:username, Techraffle.Repo)
    |> unique_constraint(:username, message: "ya está en uso")
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_email(opts)
    |> validate_username()
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Techraffle.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  def username_changeset(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:username])
    |> Ecto.Changeset.validate_required([:username])
    |> Ecto.Changeset.validate_length(:username, min: 3, max: 20)
    |> Ecto.Changeset.validate_format(:username, ~r/^\w+$/, message: "solo puede contener letras, números y guiones bajos")
    |> Ecto.Changeset.unique_constraint(:username)
  end

  def username_changeset(user, attrs, _opts \\ []) do
    user
    |> Ecto.Changeset.cast(attrs, [:username])
    |> Ecto.Changeset.validate_required([:username])
    |> Ecto.Changeset.validate_length(:username, min: 3, max: 20)
    |> Ecto.Changeset.unique_constraint(:username)
  end

end
