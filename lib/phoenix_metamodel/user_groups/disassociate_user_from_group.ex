defmodule PhoenixMetamodel.UserGroups.DisassociateUserFromGroup do
  alias PhoenixMetamodel.UserGroups.Commands.DisassociateUserFromGroupCommand
  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.UserGroups.UserGroup

  def run(params) do
    with {:ok, cmd} <- DisassociateUserFromGroupCommand.validate(params) do
      case Repo.get_by(UserGroup, user_id: cmd.user_id, group_id: cmd.group_id) do
        nil -> {:error, :not_found}
        user_group -> Repo.delete(user_group)
      end
    end
  end
end
