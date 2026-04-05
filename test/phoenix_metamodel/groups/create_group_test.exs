defmodule PhoenixMetamodel.Groups.CreateGroupTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Groups.CreateGroup

  describe "run/1" do
    test "creates a group with valid params" do
      params = %{name: "Elixir Devs", description: "A group for Elixir developers"}

      assert {:ok, group} = CreateGroup.run(params)
      assert group.name == "Elixir Devs"
      assert group.description == "A group for Elixir developers"
      assert group.id != nil
    end

    test "creates a group without an optional description" do
      params = %{name: "No Description Group"}

      assert {:ok, group} = CreateGroup.run(params)
      assert group.name == "No Description Group"
      assert group.description == nil
    end

    test "returns validation error when name is missing" do
      assert {:error, errors} = CreateGroup.run(%{description: "some description"})
      assert Keyword.has_key?(errors, :name)
    end

    test "returns validation error when all required fields are missing" do
      assert {:error, errors} = CreateGroup.run(%{})
      assert Keyword.has_key?(errors, :name)
    end
  end
end
