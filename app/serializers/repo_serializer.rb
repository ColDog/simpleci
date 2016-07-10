class RepoSerializer < ActiveModel::Serializer
  attributes :id, :name, :provider, :team, :user, :last_job, :created_at, :updated_at
end
