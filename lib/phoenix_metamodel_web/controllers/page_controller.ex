defmodule PhoenixMetamodelWeb.PageController do
  use PhoenixMetamodelWeb, :controller

  def index(conn, _params) do
    json(conn, %{ok: true})
  end
end
