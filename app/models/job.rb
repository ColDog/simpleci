class Job < ApplicationRecord
  belongs_to :repo
  belongs_to :user

  def self.pop(worker)
    raise ActiveRecord::RecordNotFound.new('Could not pop a job', Job, :id, nil) if worker.nil?

    job = Job.where(worker: nil).limit(1).update(worker: worker).first
    raise ActiveRecord::RecordNotFound.new('Could not pop a job', Job, :id, nil) unless job
    job
  end

  def output_url
    if complete
      "https://s3-#{API_CONFIG.s3_region}.amazonaws.com/#{API_CONFIG.s3_bucket}/builds/#{repo.owner}/#{repo.name}/#{key}"
    elsif worker.present?
      "#{worker}/current-state"
    end
  end

  def config_body
    repo.config.try(:body)
  end

  def cancel
    if minion.cancel
      self.update!(cancelled: true)
    end
    self
  end

  def output
    minion.output
  end

  def minion
    MinionClient.new(worker)
  end

  def auth_username
    user.username
  end

  def auth_token
    user.token
  end

end
