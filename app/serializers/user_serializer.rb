class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :provider, :uid, :created_at, :updated_at
end
