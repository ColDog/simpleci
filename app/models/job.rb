class Job < ApplicationRecord
  belongs_to :repo

  def self.pop(worker)
    if Job.where(worker: nil).update_all(worker: worker)
      Job.find_by(worker: worker).last
    end
  end

end
