class Repo < ApplicationRecord
  belongs_to :team,   optional: true
  belongs_to :user,   optional: true
  belongs_to :config, optional: true
  has_many :jobs

  def enqueue_job(branch='master')
    next_id = jobs.order(id: :desc).pluck(:job_id).first.try(:+, 1) || 1
    jobs.create!(
        branch: branch,
        job_id: next_id,
        key: "#{name}_#{branch}_#{next_id}",
    )
  end

  def config_body
    config.try(:body)
  end

  def last_job
    jobs.last
  end

end
