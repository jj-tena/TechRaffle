defmodule Techraffle.TicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Techraffle.Tickets` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        comment: "some comment",
        price: 42
      })
      |> Techraffle.Tickets.create_ticket()

    ticket
  end
end
