defmodule PhoenixMetamodelWeb.Router do
  use PhoenixMetamodelWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixMetamodelWeb do
    pipe_through :api

    get "/", PageController, :index

    resources "/users", UserController, except: [:new, :edit]
    resources "/groups", GroupController, except: [:new, :edit]

    post "/users/:user_id/groups/:group_id", UserGroupController, :create
    delete "/users/:user_id/groups/:group_id", UserGroupController, :delete
  end
end
