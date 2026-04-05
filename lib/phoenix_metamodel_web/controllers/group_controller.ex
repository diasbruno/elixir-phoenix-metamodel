defmodule PhoenixMetamodelWeb.GroupController do
  use PhoenixMetamodelWeb, :controller

  alias PhoenixMetamodel.Repo
  alias PhoenixMetamodel.Groups.Group
  alias PhoenixMetamodel.Groups.{CreateGroup, UpdateGroup, DeleteGroup}

  def index(conn, _params) do
    groups = Repo.all(Group)
    json(conn, %{data: Enum.map(groups, &group_json/1)})
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Group, id) do
      nil -> conn |> put_status(:not_found) |> json(%{errors: %{detail: "Not Found"}})
      group -> json(conn, %{data: group_json(group)})
    end
  end

  def create(conn, params) do
    case CreateGroup.run(atomize_keys(params)) do
      {:ok, group} -> conn |> put_status(:created) |> json(%{data: group_json(group)})
      {:error, errors} -> conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  def update(conn, %{"id" => _id} = params) do
    case UpdateGroup.run(atomize_keys(params)) do
      {:ok, group} -> json(conn, %{data: group_json(group)})
      {:error, :not_found} -> conn |> put_status(:not_found) |> json(%{errors: %{detail: "Not Found"}})
      {:error, errors} -> conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  def delete(conn, %{"id" => id}) do
    case DeleteGroup.run(%{id: id}) do
      {:ok, _group} -> send_resp(conn, :no_content, "")
      {:error, :not_found} -> conn |> put_status(:not_found) |> json(%{errors: %{detail: "Not Found"}})
      {:error, errors} -> conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  defp group_json(group) do
    %{id: group.id, name: group.name, description: group.description}
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
