defmodule PhoenixMetamodel.Groups.CreateGroup do
  alias PhoenixMetamodel.Groups.Commands.CreateGroupCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Groups.Group

  def run(params) do
    with {:ok, cmd} <- CreateGroupCommand.validate(params) do
      %Group{}
      |> Group.changeset(Map.from_struct(cmd))
      |> Repo.insert()
    end
  end
end
