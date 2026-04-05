defmodule PhoenixMetamodel.Users.CreateUserTest do
  use PhoenixMetamodel.DataCase, async: true

  alias PhoenixMetamodel.Users.CreateUser

  describe "run/1" do
    test "creates a user with valid params" do
      params = %{name: "Alice", email: "alice@example.com", password: "secret"}

      assert {:ok, user} = CreateUser.run(params)
      assert user.name == "Alice"
      assert user.email == "alice@example.com"
      assert user.id != nil
    end

    test "returns validation error when name is missing" do
      params = %{email: "alice@example.com", password: "secret"}

      assert {:error, errors} = CreateUser.run(params)
      assert Keyword.has_key?(errors, :name)
    end

    test "returns validation error when email is missing" do
      params = %{name: "Alice", password: "secret"}

      assert {:error, errors} = CreateUser.run(params)
      assert Keyword.has_key?(errors, :email)
    end

    test "returns validation error when password is missing" do
      params = %{name: "Alice", email: "alice@example.com"}

      assert {:error, errors} = CreateUser.run(params)
      assert Keyword.has_key?(errors, :password)
    end

    test "returns validation error when all required fields are missing" do
      assert {:error, errors} = CreateUser.run(%{})
      assert Keyword.has_key?(errors, :name)
      assert Keyword.has_key?(errors, :email)
      assert Keyword.has_key?(errors, :password)
    end
  end
end
