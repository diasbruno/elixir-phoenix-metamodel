defmodule PhoenixMetamodel.UserGroups.DisassociateUserFromGroupTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Groups.CreateGroup
  alias PhoenixMetamodel.Users.CreateUser
  alias PhoenixMetamodel.UserGroups.{AssociateUserToGroup, DisassociateUserFromGroup}

  defp create_user! do
    {:ok, user} = CreateUser.run(%{name: "Alice", email: "alice@example.com", password: "secret"})
    user
  end

  defp create_group! do
    {:ok, group} = CreateGroup.run(%{name: "Elixir Devs"})
    group
  end

  describe "run/1" do
    test "removes an existing association" do
      user = create_user!()
      group = create_group!()
      {:ok, _} = AssociateUserToGroup.run(%{user_id: user.id, group_id: group.id})

      assert {:ok, removed} =
               DisassociateUserFromGroup.run(%{user_id: user.id, group_id: group.id})

      assert removed.user_id == user.id
      assert removed.group_id == group.id
    end

    test "returns not_found when the association does not exist" do
      user = create_user!()
      group = create_group!()

      assert {:error, :not_found} =
               DisassociateUserFromGroup.run(%{user_id: user.id, group_id: group.id})
    end

    test "returns validation error when user_id is missing" do
      group = create_group!()
      assert {:error, errors} = DisassociateUserFromGroup.run(%{group_id: group.id})
      assert Keyword.has_key?(errors, :user_id)
    end

    test "returns validation error when group_id is missing" do
      user = create_user!()
      assert {:error, errors} = DisassociateUserFromGroup.run(%{user_id: user.id})
      assert Keyword.has_key?(errors, :group_id)
    end

    test "returns validation error when all params are missing" do
      assert {:error, errors} = DisassociateUserFromGroup.run(%{})
      assert Keyword.has_key?(errors, :user_id)
      assert Keyword.has_key?(errors, :group_id)
    end
  end
end
