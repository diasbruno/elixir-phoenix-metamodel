defmodule PhoenixMetamodelWeb.PageController do
  use PhoenixMetamodelWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
