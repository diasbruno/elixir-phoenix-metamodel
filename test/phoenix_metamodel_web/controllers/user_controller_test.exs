defmodule PhoenixMetamodelWeb.UserControllerTest do
  use PhoenixMetamodelWeb.ConnCase

  alias PhoenixMetamodel.Users.CreateUser

  setup do
    {:ok, user} =
      CreateUser.run(%{"name" => "Alice", "email" => "alice@example.com", "password" => "secret"})

    %{user: user}
  end

  describe "GET /api/users" do
    test "returns a list of users", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users")
      assert %{"data" => users} = json_response(conn, 200)
      assert Enum.any?(users, fn u -> u["id"] == user.id end)
    end
  end

  describe "GET /api/users/:id" do
    test "returns the user when found", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users/#{user.id}")
      assert %{"data" => data} = json_response(conn, 200)
      assert data["id"] == user.id
      assert data["name"] == user.name
      assert data["email"] == user.email
    end

    test "returns 404 when not found", %{conn: conn} do
      conn = get(conn, ~p"/api/users/00000000-0000-0000-0000-000000000000")
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "POST /api/users" do
    test "creates a user with valid params", %{conn: conn} do
      params = %{name: "Bob", email: "bob@example.com", password: "hunter2"}
      conn = post(conn, ~p"/api/users", params)
      assert %{"data" => data} = json_response(conn, 201)
      assert data["name"] == "Bob"
      assert data["email"] == "bob@example.com"
    end

    test "returns 422 with invalid params", %{conn: conn} do
      conn = post(conn, ~p"/api/users", %{})
      assert json_response(conn, 422)["errors"]
    end
  end

  describe "PUT /api/users/:id" do
    test "updates the user with valid params", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user.id}", %{name: "Alice Updated", email: "alice@example.com"})
      assert %{"data" => data} = json_response(conn, 200)
      assert data["name"] == "Alice Updated"
    end

    test "returns 404 when not found", %{conn: conn} do
      conn =
        put(conn, ~p"/api/users/00000000-0000-0000-0000-000000000000",
          name: "Ghost",
          email: "ghost@example.com"
        )

      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end

    test "returns 422 with invalid params", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user.id}", %{name: "", email: ""})
      assert json_response(conn, 422)["errors"]
    end
  end

  describe "DELETE /api/users/:id" do
    test "deletes the user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user.id}")
      assert response(conn, 204)
    end

    test "returns 404 when not found", %{conn: conn} do
      conn = delete(conn, ~p"/api/users/00000000-0000-0000-0000-000000000000")
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end
end
