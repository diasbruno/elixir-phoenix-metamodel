defmodule PhoenixMetamodelWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, channels, and so on.

  This can be used in your application as:

      use PhoenixMetamodelWeb, :controller

  The definitions below will be executed for every controller,
  so keep them short and clean, focused on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:json]

      import Plug.Conn
      import PhoenixMetamodelWeb.Gettext

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: PhoenixMetamodelWeb.Endpoint,
        router: PhoenixMetamodelWeb.Router,
        statics: []
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
