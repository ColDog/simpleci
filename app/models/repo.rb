class Repo < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :jobs

  def enqueue_job(branch)
    next_id = jobs.last.pluck(:job_id).try(:+, 1) || 1
    jobs.create!(
        branch: branch,
        job_id: next_id,
        key: "#{name}.#{branch}.#{next_id}",
    )
  end

end
