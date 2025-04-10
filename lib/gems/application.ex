defmodule GEMS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GEMSWeb.Telemetry,
      GEMS.Repo,
      {DNSCluster, query: Application.get_env(:gems, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GEMS.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GEMS.Finch},
      # Start a worker by calling: GEMS.Worker.start_link(arg)
      # {GEMS.Worker, arg},
      # Start to serve requests, typically the last entry
      GEMSWeb.Endpoint,
      GEMS.ActivityManager,
      GEMS.BattleManager,
      GEMSLua.Manager,
      {Cachex, [:gems]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GEMS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GEMSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
