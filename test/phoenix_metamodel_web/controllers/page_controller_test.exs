defmodule PhoenixMetamodelWeb.PageControllerTest do
  use PhoenixMetamodelWeb.ConnCase

  test "GET /api/", %{conn: conn} do
    conn = get(conn, ~p"/api/")
    assert json_response(conn, 200) == %{"ok" => true}
  end
end
