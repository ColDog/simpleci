class JobDefinition < ApplicationRecord
  belongs_to  :user
  has_many    :jobs

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

  def repo_name
    repo[:name] || name
  end

end
