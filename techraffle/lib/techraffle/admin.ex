defmodule Techraffle.Admin do
  import Ecto.Query
  alias Techraffle.Raffles.Raffle
  alias Techraffle.Raffles
  alias Techraffle.Repo

  def list_raffles do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

  def change_raffle(%Raffle{} = raffle, attrs \\ %{}) do
    Raffle.changeset(raffle, attrs)
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def update_raffle(%Raffle{} = raffle, attrs) do
    raffle
    |> Raffle.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, raffle} ->
        raffle = Repo.preload(raffle, [:charity, :winning_ticket])
        Raffles.broadcast(raffle.id, {:raffle_updated, raffle})
        {:ok, raffle}

      {:error, _} = error ->
        error
    end
  end

  def delete_raffle(%Raffle{} = raffle) do
    Repo.delete(raffle)
  end

  def draw_winner(%Raffle{status: :close} = raffle) do
    raffle = Repo.preload(raffle, :tickets)

    case raffle.tickets do
      [] ->
        {:error, "No hay tickets entre los que elegir un ganador"}
      tickets ->
        winner = Enum.random(tickets)
        {:ok, _raffle} = update_raffle(raffle, %{
          winning_ticket_id: winner.id
        })
    end
  end

  def draw_winner(%Raffle{}) do
    {:error, "El sorteo debe estar cerrado para elegir un ganador"}
  end

end
