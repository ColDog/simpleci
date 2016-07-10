class Job < ApplicationRecord
  belongs_to :repo

  def self.pop(worker)
    Job.where(worker: nil).limit(1).update(worker: worker).first
  end

  def output_url
    if complete
      "http://permanent-storage/#{key}"
    else
      "http://#{worker}/current-state"
    end
  end

  def config
    repo.config.try(:config)
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

end
