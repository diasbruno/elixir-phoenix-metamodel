defmodule PhoenixMetamodel.Groups.DeleteGroupTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Groups.{CreateGroup, DeleteGroup}
  alias PhoenixMetamodel.{Repo, Groups.Group}

  defp create_group! do
    {:ok, group} = CreateGroup.run(%{name: "To Delete"})
    group
  end

  describe "run/1" do
    test "deletes an existing group" do
      group = create_group!()

      assert {:ok, deleted} = DeleteGroup.run(%{id: group.id})
      assert deleted.id == group.id
      assert Repo.get(Group, group.id) == nil
    end

    test "returns not_found when the group does not exist" do
      assert {:error, :not_found} = DeleteGroup.run(%{id: Ecto.UUID.generate()})
    end

    test "returns validation error when id is missing" do
      assert {:error, errors} = DeleteGroup.run(%{})
      assert Keyword.has_key?(errors, :id)
    end
  end
end
