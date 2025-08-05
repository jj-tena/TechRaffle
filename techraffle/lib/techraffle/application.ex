defmodule Techraffle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TechraffleWeb.Telemetry,
      Techraffle.Repo,
      {DNSCluster, query: Application.get_env(:techraffle, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Techraffle.PubSub},
      TechraffleWeb.Presence,
      # Start the Finch HTTP client for sending emails
      {Finch, name: Techraffle.Finch},
      # Start a worker by calling: Techraffle.Worker.start_link(arg)
      # {Techraffle.Worker, arg},
      # Start to serve requests, typically the last entry
      TechraffleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Techraffle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TechraffleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
