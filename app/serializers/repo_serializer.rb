class RepoSerializer < ActiveModel::Serializer
  attributes :id, :name, :provider, :team, :user, :last_job, :config_body, :created_at, :updated_at
end
