class JobSerializer < ActiveModel::Serializer
  attributes :id, :key, :job_id, :branch, :repo, :completed, :failed, :cancelled, :failure, :worker, :output_url
end
