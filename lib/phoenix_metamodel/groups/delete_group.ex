defmodule PhoenixMetamodel.Groups.DeleteGroup do
  alias PhoenixMetamodel.Groups.Commands.DeleteGroupCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Groups.Group

  def run(params) do
    with {:ok, cmd} <- DeleteGroupCommand.validate(params) do
      case Repo.get(Group, cmd.id) do
        nil -> {:error, :not_found}
        group -> Repo.delete(group)
      end
    end
  end
end
