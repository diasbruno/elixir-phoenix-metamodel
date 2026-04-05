defmodule PhoenixMetamodelWeb.UserGroupControllerTest do
  use PhoenixMetamodelWeb.ConnCase

  alias PhoenixMetamodel.Users.CreateUser
  alias PhoenixMetamodel.Groups.CreateGroup
  alias PhoenixMetamodel.UserGroups.AssociateUserToGroup

  setup do
    {:ok, user} =
      CreateUser.run(%{"name" => "Alice", "email" => "alice@example.com", "password" => "secret"})

    {:ok, group} = CreateGroup.run(%{"name" => "Admins"})

    %{user: user, group: group}
  end

  describe "POST /api/users/:user_id/groups/:group_id" do
    test "associates a user to a group", %{conn: conn, user: user, group: group} do
      conn = post(conn, ~p"/api/users/#{user.id}/groups/#{group.id}")
      assert %{"data" => data} = json_response(conn, 201)
      assert data["user_id"] == user.id
      assert data["group_id"] == group.id
    end

    test "returns 422 when already associated", %{conn: conn, user: user, group: group} do
      {:ok, _} = AssociateUserToGroup.run(%{user_id: user.id, group_id: group.id})
      conn = post(conn, ~p"/api/users/#{user.id}/groups/#{group.id}")
      assert json_response(conn, 422)["errors"]
    end
  end

  describe "DELETE /api/users/:user_id/groups/:group_id" do
    test "disassociates a user from a group", %{conn: conn, user: user, group: group} do
      {:ok, _} = AssociateUserToGroup.run(%{user_id: user.id, group_id: group.id})
      conn = delete(conn, ~p"/api/users/#{user.id}/groups/#{group.id}")
      assert response(conn, 204)
    end

    test "returns 404 when association does not exist", %{conn: conn, user: user, group: group} do
      conn = delete(conn, ~p"/api/users/#{user.id}/groups/#{group.id}")
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end
end
