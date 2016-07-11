class Job < ApplicationRecord
  belongs_to :repo
  belongs_to :user

  def self.pop(worker)
    job = Job.where(worker: nil).limit(1).update(worker: worker).first
    raise ActiveRecord::RecordNotFound.new('Could not pop a job', Job, :id, nil) unless job
    job
  end

  def output_url
    if complete
      "http://permanent-storage/#{key}"
    else
      "http://#{worker}/current-state"
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
