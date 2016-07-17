class JobSerializer < ActiveModel::Serializer
  cache
  attributes :id, :key, :job_id, :branch, :repo, :complete, :failed, :cancelled, :failure, :worker,
             :output_url, :build, :created_at, :updated_at
end
