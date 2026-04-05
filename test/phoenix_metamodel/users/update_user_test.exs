defmodule PhoenixMetamodel.Users.UpdateUserTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Users.{CreateUser, UpdateUser}

  defp create_user! do
    {:ok, user} =
      CreateUser.run(%{name: "Alice", email: "alice@example.com", password: "secret"})

    user
  end

  describe "run/1" do
    test "updates an existing user with valid params" do
      user = create_user!()
      params = %{id: user.id, name: "Alice Updated", email: "alice2@example.com"}

      assert {:ok, updated} = UpdateUser.run(params)
      assert updated.name == "Alice Updated"
      assert updated.email == "alice2@example.com"
    end

    test "returns not_found when the user does not exist" do
      params = %{id: Ecto.UUID.generate(), name: "Bob", email: "bob@example.com"}

      assert {:error, :not_found} = UpdateUser.run(params)
    end

    test "returns validation error when id is missing" do
      params = %{name: "Alice", email: "alice@example.com"}

      assert {:error, errors} = UpdateUser.run(params)
      assert Keyword.has_key?(errors, :id)
    end

    test "returns validation error when name is missing" do
      user = create_user!()
      params = %{id: user.id, email: "alice@example.com"}

      assert {:error, errors} = UpdateUser.run(params)
      assert Keyword.has_key?(errors, :name)
    end
  end
end
