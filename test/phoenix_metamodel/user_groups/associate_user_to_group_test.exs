defmodule PhoenixMetamodel.UserGroups.AssociateUserToGroupTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Groups.CreateGroup
  alias PhoenixMetamodel.Users.CreateUser
  alias PhoenixMetamodel.UserGroups.AssociateUserToGroup

  defp create_user! do
    {:ok, user} = CreateUser.run(%{name: "Alice", email: "alice@example.com", password: "secret"})
    user
  end

  defp create_group! do
    {:ok, group} = CreateGroup.run(%{name: "Elixir Devs"})
    group
  end

  describe "run/1" do
    test "associates a user to a group with valid params" do
      user = create_user!()
      group = create_group!()

      assert {:ok, user_group} =
               AssociateUserToGroup.run(%{user_id: user.id, group_id: group.id})

      assert user_group.user_id == user.id
      assert user_group.group_id == group.id
    end

    test "returns a db error when the same association already exists" do
      user = create_user!()
      group = create_group!()
      params = %{user_id: user.id, group_id: group.id}

      assert {:ok, _} = AssociateUserToGroup.run(params)
      assert {:error, changeset} = AssociateUserToGroup.run(params)
      assert changeset.errors[:user_id] != nil or changeset.errors[:group_id] != nil
    end

    test "returns validation error when user_id is missing" do
      group = create_group!()
      assert {:error, errors} = AssociateUserToGroup.run(%{group_id: group.id})
      assert Keyword.has_key?(errors, :user_id)
    end

    test "returns validation error when group_id is missing" do
      user = create_user!()
      assert {:error, errors} = AssociateUserToGroup.run(%{user_id: user.id})
      assert Keyword.has_key?(errors, :group_id)
    end

    test "returns validation error when all params are missing" do
      assert {:error, errors} = AssociateUserToGroup.run(%{})
      assert Keyword.has_key?(errors, :user_id)
      assert Keyword.has_key?(errors, :group_id)
    end
  end
end
