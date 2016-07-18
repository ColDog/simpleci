class JobDefinitionSerializer < ActiveModel::Serializer
  attributes :id, :name, :triggered_by, :repo, :build
end
