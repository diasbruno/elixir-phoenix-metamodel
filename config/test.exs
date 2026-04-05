import Config

config :phoenix_metamodel, PhoenixMetamodel.Repo,
  database: Path.expand("../phoenix_metamodel_test#{System.get_env("MIX_TEST_PARTITION")}.db", __DIR__),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :phoenix_metamodel, PhoenixMetamodelWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oPJ9PFNFv0IaAULFnx7oMN3LIJeGBBHMQGDsJxP9jlIqkFJAyRhZ8aIJQFPKRbFV",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false
