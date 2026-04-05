import Config

config :phoenix_metamodel, PhoenixMetamodel.Repo,
  database: Path.expand("../phoenix_metamodel_dev.db", __DIR__),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 5,
  journal_mode: :wal

config :phoenix_metamodel, PhoenixMetamodelWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "iqVHFq4OB8eIrJHCzJmH8GVXAWD6rqLIqmMLTt+AGJR7pXdBUYCiMYdBJBFVT3m"

config :phoenix_metamodel, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false

config :logger, level: :debug
