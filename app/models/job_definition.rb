class JobDefinition < ApplicationRecord
  belongs_to  :user
  has_many    :jobs

  validates_presence_of :name
  validates :repo_exists

  def state
    jobs.last.try(:state)
  end

  def last_build
    jobs.last.try(:key)
  end

  def last_job
    jobs.last
  end

  # REPO should have the following structure
  # name: <repository name>
  # owner: <repository owner>
  # provider: <repository provider (github)>
  def repo
    (super || {}).deep_symbolize_keys
  end

  def build
    (super || {}).deep_symbolize_keys
  end

  def triggered_by
    super || []
  end

  def repo_name
    repo[:project] || name
  end

  def repo_owner
    repo[:owner]
  end

  def repo_exists
    if repo_name
      errors.add(:repo, 'Does not exist') unless user.client.repo(repo_name)[:id].present?
    end
  end

end
