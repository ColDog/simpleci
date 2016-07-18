class TokenSerializer < ActiveModel::Serializer
  attributes :id, :key, :updated_at, :created_at
end
