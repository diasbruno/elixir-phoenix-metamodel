defmodule PhoenixMetamodel.Groups.UpdateGroupTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Groups.{CreateGroup, UpdateGroup}

  defp create_group! do
    {:ok, group} = CreateGroup.run(%{name: "Original", description: "desc"})
    group
  end

  describe "run/1" do
    test "updates an existing group with valid params" do
      group = create_group!()
      params = %{id: group.id, name: "Updated", description: "new desc"}

      assert {:ok, updated} = UpdateGroup.run(params)
      assert updated.name == "Updated"
      assert updated.description == "new desc"
    end

    test "updates a group clearing the optional description" do
      group = create_group!()
      params = %{id: group.id, name: "Updated", description: nil}

      assert {:ok, updated} = UpdateGroup.run(params)
      assert updated.name == "Updated"
      assert updated.description == nil
    end

    test "returns not_found when the group does not exist" do
      params = %{id: Ecto.UUID.generate(), name: "Ghost", description: nil}

      assert {:error, :not_found} = UpdateGroup.run(params)
    end

    test "returns validation error when id is missing" do
      assert {:error, errors} = UpdateGroup.run(%{name: "No ID"})
      assert Keyword.has_key?(errors, :id)
    end

    test "returns validation error when name is missing" do
      group = create_group!()
      assert {:error, errors} = UpdateGroup.run(%{id: group.id})
      assert Keyword.has_key?(errors, :name)
    end
  end
end
