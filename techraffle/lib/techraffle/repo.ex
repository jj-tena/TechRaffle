defmodule Techraffle.Repo do
  use Ecto.Repo,
    otp_app: :techraffle,
    adapter: Ecto.Adapters.Postgres
end
