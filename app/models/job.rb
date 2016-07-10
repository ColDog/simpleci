class Job < ApplicationRecord
  belongs_to :repo

  def self.pop(worker)
    if Job.where(worker: nil).update_all(worker: worker)
      Job.find_by(worker: worker).last
    end
  end

  def output_url
    if completed
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
