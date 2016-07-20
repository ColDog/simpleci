class JobDefinition < ApplicationRecord
  belongs_to  :user
  has_many    :jobs

  def state
    jobs.last.try(:state)
  end

  def last_build
    jobs.last.try(:key)
  end

  # REPO should have the following structure
  # name: <repository name>
  # owner: <repository owner>
  # provider: <repository provider (github)>
  def repo
    (super || {}).symbolize_keys
  end

  def build
    (super || {}).symbolize_keys
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

end
