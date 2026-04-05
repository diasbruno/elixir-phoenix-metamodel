defmodule PhoenixMetamodel.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_metamodel,
    adapter: Ecto.Adapters.Postgres
end
