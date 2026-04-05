defmodule PhoenixMetamodel.Users.DeleteUserTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Users.{CreateUser, DeleteUser}
  alias PhoenixMetamodel.{Repo, Users.User}

  defp create_user! do
    {:ok, user} =
      CreateUser.run(%{name: "Alice", email: "alice@example.com", password: "secret"})

    user
  end

  describe "run/1" do
    test "deletes an existing user" do
      user = create_user!()

      assert {:ok, deleted} = DeleteUser.run(%{id: user.id})
      assert deleted.id == user.id
      assert Repo.get(User, user.id) == nil
    end

    test "returns not_found when the user does not exist" do
      assert {:error, :not_found} = DeleteUser.run(%{id: Ecto.UUID.generate()})
    end

    test "returns validation error when id is missing" do
      assert {:error, errors} = DeleteUser.run(%{})
      assert Keyword.has_key?(errors, :id)
    end
  end
end
