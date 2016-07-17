class UserSerializer < ActiveModel::Serializer
  cache
  attributes :id, :email, :username, :name, :provider, :uid, :created_at, :updated_at
end
