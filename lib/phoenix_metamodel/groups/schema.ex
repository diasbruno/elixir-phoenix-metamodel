defmodule PhoenixMetamodel.Groups.Schema do
  use MetaDsl

  meta_type :group do
    property :id,          :uuid,   required: true
    property :name,        :string, required: true
    property :description, :string
  end

  subtype :create_group_command, from: :group, except: [:id]
  subtype :update_group_command, from: :group, only: [:id, :name, :description]
  subtype :delete_group_command, from: :group, only: [:id]
end
