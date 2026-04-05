defmodule PhoenixMetamodelWeb.UserGroupController do
  use PhoenixMetamodelWeb, :controller

  alias PhoenixMetamodel.UserGroups.{AssociateUserToGroup, DisassociateUserFromGroup}

  def create(conn, %{"user_id" => user_id, "group_id" => group_id}) do
    case AssociateUserToGroup.run(%{user_id: user_id, group_id: group_id}) do
      {:ok, user_group} ->
        conn
        |> put_status(:created)
        |> json(%{data: %{user_id: user_group.user_id, group_id: user_group.group_id}})

      {:error, errors} ->
        conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  def delete(conn, %{"user_id" => user_id, "group_id" => group_id}) do
    case DisassociateUserFromGroup.run(%{user_id: user_id, group_id: group_id}) do
      {:ok, _user_group} -> send_resp(conn, :no_content, "")
      {:error, :not_found} -> conn |> put_status(:not_found) |> json(%{errors: %{detail: "Not Found"}})
      {:error, errors} -> conn |> put_status(:unprocessable_entity) |> json(%{errors: format_errors(errors)})
    end
  end

  defp format_errors(errors) when is_list(errors), do: Map.new(errors)

  defp format_errors(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
