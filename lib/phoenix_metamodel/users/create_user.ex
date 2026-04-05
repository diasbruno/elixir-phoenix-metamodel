defmodule PhoenixMetamodel.Users.CreateUser do
  alias PhoenixMetamodel.Users.Commands.CreateUserCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Users.User

  def run(params) do
    with {:ok, cmd} <- CreateUserCommand.validate(params) do
      %User{}
      |> User.changeset(Map.from_struct(cmd))
      |> Repo.insert()
    end
  end
end
