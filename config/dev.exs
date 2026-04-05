import Config

config :phoenix_metamodel, PhoenixMetamodel.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "phoenix_metamodel_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :phoenix_metamodel, PhoenixMetamodelWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "iqVHFq4OB8eIrJHCzJmH8GVXAWD6rqLIqmMLTt+AGJR7pXdBUYCiMYdBJBFVT3m",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:phoenix_metamodel, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:phoenix_metamodel, ~w(--watch)]}
  ]

config :phoenix_metamodel, PhoenixMetamodelWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/phoenix_metamodel_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :phoenix_metamodel, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false

config :phoenix_metamodel, :dev_routes, true

config :logger, level: :debug
