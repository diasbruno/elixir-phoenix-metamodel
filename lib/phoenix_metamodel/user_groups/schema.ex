defmodule PhoenixMetamodel.UserGroups.Schema do
  use MetaDsl

  meta_type :user_group do
    property :user_id,  :uuid, required: true
    property :group_id, :uuid, required: true
  end

  subtype :associate_user_to_group_command,    from: :user_group, only: [:user_id, :group_id]
  subtype :disassociate_user_from_group_command, from: :user_group, only: [:user_id, :group_id]
end
