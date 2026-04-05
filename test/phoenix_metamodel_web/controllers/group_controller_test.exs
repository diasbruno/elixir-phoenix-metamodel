defmodule PhoenixMetamodelWeb.GroupControllerTest do
  use PhoenixMetamodelWeb.ConnCase

  alias PhoenixMetamodel.Groups.CreateGroup

  setup do
    {:ok, group} = CreateGroup.run(%{"name" => "Admins", "description" => "Admin group"})
    %{group: group}
  end

  describe "GET /api/groups" do
    test "returns a list of groups", %{conn: conn, group: group} do
      conn = get(conn, ~p"/api/groups")
      assert %{"data" => groups} = json_response(conn, 200)
      assert Enum.any?(groups, fn g -> g["id"] == group.id end)
    end
  end

  describe "GET /api/groups/:id" do
    test "returns the group when found", %{conn: conn, group: group} do
      conn = get(conn, ~p"/api/groups/#{group.id}")
      assert %{"data" => data} = json_response(conn, 200)
      assert data["id"] == group.id
      assert data["name"] == group.name
    end

    test "returns 404 when not found", %{conn: conn} do
      conn = get(conn, ~p"/api/groups/00000000-0000-0000-0000-000000000000")
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "POST /api/groups" do
    test "creates a group with valid params", %{conn: conn} do
      conn = post(conn, ~p"/api/groups", %{name: "Editors"})
      assert %{"data" => data} = json_response(conn, 201)
      assert data["name"] == "Editors"
    end

    test "creates a group with an optional description", %{conn: conn} do
      conn = post(conn, ~p"/api/groups", %{name: "Writers", description: "Content writers"})
      assert %{"data" => data} = json_response(conn, 201)
      assert data["description"] == "Content writers"
    end

    test "returns 422 with invalid params", %{conn: conn} do
      conn = post(conn, ~p"/api/groups", %{})
      assert json_response(conn, 422)["errors"]
    end
  end

  describe "PUT /api/groups/:id" do
    test "updates the group with valid params", %{conn: conn, group: group} do
      conn = put(conn, ~p"/api/groups/#{group.id}", %{name: "Super Admins"})
      assert %{"data" => data} = json_response(conn, 200)
      assert data["name"] == "Super Admins"
    end

    test "returns 404 when not found", %{conn: conn} do
      conn = put(conn, ~p"/api/groups/00000000-0000-0000-0000-000000000000", %{name: "Ghost"})
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end

    test "returns 422 with invalid params", %{conn: conn, group: group} do
      conn = put(conn, ~p"/api/groups/#{group.id}", %{name: ""})
      assert json_response(conn, 422)["errors"]
    end
  end

  describe "DELETE /api/groups/:id" do
    test "deletes the group", %{conn: conn, group: group} do
      conn = delete(conn, ~p"/api/groups/#{group.id}")
      assert response(conn, 204)
    end

    test "returns 404 when not found", %{conn: conn} do
      conn = delete(conn, ~p"/api/groups/00000000-0000-0000-0000-000000000000")
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end
end
