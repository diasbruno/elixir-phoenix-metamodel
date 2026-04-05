defmodule PhoenixMetamodel.Users.DeleteUser do
  alias PhoenixMetamodel.Users.Commands.DeleteUserCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Users.User

  def run(params) do
    with {:ok, cmd} <- DeleteUserCommand.validate(params) do
      case Repo.get(User, cmd.id) do
        nil -> {:error, :not_found}
        user -> Repo.delete(user)
      end
    end
  end
end
