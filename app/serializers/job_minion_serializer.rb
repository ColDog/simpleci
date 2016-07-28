class JobMinionSerializer < ActiveModel::Serializer
  attributes :id, :key, :user_id, :job_family, :build, :repo

  def build
    object.build_for_minion
  end

  def repo
    object.repo_for_minion
  end

  def user_id
    object.user.id
  end

end
