class Repo < ApplicationRecord
  belongs_to :team,   optional: true
  belongs_to :user,   optional: true
  belongs_to :config, optional: true
  has_many :jobs

  def enqueue_job(branch)
    next_id = jobs.last.pluck(:job_id).try(:+, 1) || 1
    jobs.create!(
        branch: branch,
        job_id: next_id,
        key: "#{name}.#{branch}.#{next_id}",
    )
  end

  def last_job
    jobs.last
  end

end
