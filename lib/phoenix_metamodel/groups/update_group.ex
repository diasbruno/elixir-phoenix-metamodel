defmodule PhoenixMetamodel.Groups.UpdateGroup do
  alias PhoenixMetamodel.Groups.Commands.UpdateGroupCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Groups.Group

  def run(params) do
    with {:ok, cmd} <- UpdateGroupCommand.validate(params) do
      case Repo.get(Group, cmd.id) do
        nil -> {:error, :not_found}
        group -> group |> Group.update_changeset(Map.from_struct(cmd)) |> Repo.update()
      end
    end
  end
end
