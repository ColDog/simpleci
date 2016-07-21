class JobSerializer < ActiveModel::Serializer
  cache
  attributes :id, :key, :job_id, :job_family, :worker, :state, :output_url, :repo, :build, :created_at, :updated_at,
             :complete, :failed, :cancelled, :failure

end
