defmodule PhoenixMetamodelWeb.UserController do
  use PhoenixMetamodelWeb, :controller

  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Users.User
  alias PhoenixMetamodel.Users.{CreateUser, UpdateUser, DeleteUser}

  def index(conn, _params) do
    users = Repo.all(User)
    json(conn, %{data: Enum.map(users, &user_json/1)})
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil -> conn |> put_status(:not_found) |> json(%{errors: %{detail: "Not Found"}})
      user -> json(conn, %{data: user_json(user)})
    end
  end

  def create(conn, params) do
    case CreateUser.run(atomize_keys(params)) do
      {:ok, user} -> conn |> put_status(:created) |> json(%{data: user_json(user)})
      {:error, errors} -> conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  def update(conn, %{"id" => _id} = params) do
    case UpdateUser.run(atomize_keys(params)) do
      {:ok, user} -> json(conn, %{data: user_json(user)})
      {:error, :not_found} -> conn |> put_status(:not_found) |> json(%{errors: %{detail: "Not Found"}})
      {:error, errors} -> conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  def delete(conn, %{"id" => id}) do
    case DeleteUser.run(%{id: id}) do
      {:ok, _user} -> send_resp(conn, :no_content, "")
      {:error, :not_found} -> conn |> put_status(:not_found) |> json(%{errors: %{detail: "Not Found"}})
      {:error, errors} -> conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  defp user_json(user) do
    %{id: user.id, name: user.name, email: user.email}
  end

  defp format_errors(errors) when is_list(errors), do: Map.new(errors)

  defp format_errors(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end

  defp atomize_keys(params) when is_map(params) do
    Map.new(params, fn
      {k, v} when is_binary(k) ->
        try do
          {String.to_existing_atom(k), v}
        rescue
          ArgumentError -> {k, v}
        end

      {k, v} ->
        {k, v}
    end)
  end
end
