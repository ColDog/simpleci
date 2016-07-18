class Job < ApplicationRecord
  belongs_to :user
  belongs_to :job_definition

  def self.pop(worker)
    raise ActiveRecord::RecordNotFound.new('Could not pop a job', Job, :id, nil) if worker.nil?

    job = Job.where(worker: nil).limit(1).update(worker: worker).first
    raise ActiveRecord::RecordNotFound.new('Could not pop a job', Job, :id, nil) unless job
    job
  end

  def build
    super.try(:symbolize_keys)
  end

  def output_url
    if complete
      stored_output_url
    elsif worker.present?
      "#{worker}/current-state"
    end
  end

  def config_body
    repo.config.try(:body)
  end

  def minion
    MinionClient.new(worker)
  end

  def owner
    job_definition.user
  end

  def build_for_minion
    val = build
    val[:env] = val[:env].map { |k, v| "#{k}=#{v}" }
    val
  end

  def repo_for_minion
    repo.merge(auth_user: user.username, auth_token: user.token)
  end

end
