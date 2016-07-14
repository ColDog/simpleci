class RepoSerializer < ActiveModel::Serializer
  attributes :id, :name, :provider, :team, :user, :last_job, :job_count, :config_body, :config_id, :created_at, :updated_at
end
