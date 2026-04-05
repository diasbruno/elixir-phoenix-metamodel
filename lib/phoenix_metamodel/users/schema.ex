defmodule PhoenixMetamodel.Users.Schema do
  use MetaDsl

  meta_type :user do
    property :id,       :uuid,   required: true
    property :name,     :string, required: true
    property :email,    :string, required: true
    property :password, :string, required: true
  end

  subtype :create_user_command, from: :user, except: [:id]
  subtype :update_user_command, from: :user, only: [:id, :name, :email]
  subtype :delete_user_command, from: :user, only: [:id]
end
