class JobSerializer < ActiveModel::Serializer
  cache
  attributes :id, :key, :job_id, :worker, :state, :output_url, :repo, :build, :created_at, :updated_at,
             :complete, :failed, :cancelled, :failure

end
