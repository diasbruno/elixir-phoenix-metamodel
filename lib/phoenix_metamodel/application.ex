defmodule PhoenixMetamodel.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixMetamodelWeb.Telemetry,
      PhoenixMetamodel.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_metamodel, :dns_cluster_query, :ignore)},
      {Phoenix.PubSub, name: PhoenixMetamodel.PubSub},
      {Finch, name: PhoenixMetamodel.Finch},
      PhoenixMetamodelWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PhoenixMetamodel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PhoenixMetamodelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
