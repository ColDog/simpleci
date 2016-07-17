class TeamSerializer < ActiveModel::Serializer
  cache
  attributes :id, :name, :created_at, :updated_at
end
