class JobDefinitionSerializer < ActiveModel::Serializer
  attributes :id, :name, :triggered_by, :state, :last_build, :repo_name, :repo_owner, :repo, :build
end
