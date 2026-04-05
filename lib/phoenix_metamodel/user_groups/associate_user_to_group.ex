defmodule PhoenixMetamodel.UserGroups.AssociateUserToGroup do
  alias PhoenixMetamodel.UserGroups.Commands.AssociateUserToGroupCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.UserGroups.UserGroup

  def run(params) do
    with {:ok, cmd} <- AssociateUserToGroupCommand.validate(params) do
      %UserGroup{}
      |> UserGroup.changeset(Map.from_struct(cmd))
      |> Repo.insert()
    end
  end
end
