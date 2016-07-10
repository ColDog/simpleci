class JobSerializer < ActiveModel::Serializer
  attributes :id, :key, :job_id, :branch, :repo, :complete, :failed, :cancelled, :failure, :worker,
             :output_url, :config, :created_at, :updated_at
end