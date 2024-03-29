defmodule Realtime.Application do
  @moduledoc """
  Application module for Realtime.
  """
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RealtimeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:realtime, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Realtime.PubSub},
      Realtime.Storage.Supervisor,
      RealtimeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Realtime.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RealtimeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
