class Repo < ApplicationRecord
  belongs_to :team,   optional: true
  belongs_to :user,   optional: true
  belongs_to :config, optional: true
  has_many :jobs

  def config_body
    HashWithIndifferentAccess.new(config.try(:body))
  end

  def last_job
    jobs.last
  end

  # todo: handle teams in these methods
  def owner
    user.username
  end

  def auth_username
    user.username
  end

  def auth_token
    user.token
  end

end
