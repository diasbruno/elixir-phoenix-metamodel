defmodule PhoenixMetamodel.Users.UpdateUser do
  alias PhoenixMetamodel.Users.Commands.UpdateUserCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Users.User

  def run(params) do
    with {:ok, cmd} <- UpdateUserCommand.validate(params) do
      case Repo.get(User, cmd.id) do
        nil -> {:error, :not_found}
        user -> user |> User.update_changeset(Map.from_struct(cmd)) |> Repo.update()
      end
    end
  end
end
