defmodule PhoenixMetamodelWeb.Router do
  use PhoenixMetamodelWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixMetamodelWeb do
    pipe_through :api

    get "/", PageController, :index
  end
end
