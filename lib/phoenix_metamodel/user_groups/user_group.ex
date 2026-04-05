defmodule PhoenixMetamodel.UserGroups.UserGroup do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_groups" do
    belongs_to :user, PhoenixMetamodel.Users.User
    belongs_to :group, PhoenixMetamodel.Groups.Group
  end

  def changeset(user_group, attrs) do
    user_group
    |> cast(attrs, [:user_id, :group_id])
    |> validate_required([:user_id, :group_id])
    |> unique_constraint([:user_id, :group_id])
  end
end
