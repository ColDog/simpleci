class Job < ApplicationRecord
  belongs_to :user
  belongs_to :job_definition

  def self.pop(worker)
    raise ActiveRecord::RecordNotFound.new('Could not pop a job', Job, :id, nil) if worker.nil?

    job = Job.where(worker: nil).limit(1).update(worker: worker).first
    raise ActiveRecord::RecordNotFound.new('Could not pop a job', Job, :id, nil) unless job
    job
  end

  def build
    super.try(:symbolize_keys)
  end

  def output_url
    if complete
      "https://s3-#{API_CONFIG.s3_region}.amazonaws.com/#{API_CONFIG.s3_bucket}/builds/#{repo.owner}/#{repo.name}/#{key}"
    elsif worker.present?
      "#{worker}/current-state"
    end
  end

  def config_body
    repo.config.try(:body)
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

  def auth_username
    user.username
  end

  def auth_token
    user.token
  end

  def owner
    job_definition.user
  end

  def build_with_variables
    # str = JSON.generate(build)
    # str.scan(/\$\{[^\}]+\}/).each do |match|
    #   key = match.match(/\$\{(.*)\}/)[1].strip
    #   str.gsub!(match, "#{owner.variables.find_by(key: key).try(:get_value)}")
    # end
    # JSON.parse(str).symbolize_keys
    build
  end

  def build_for_minion
    val = build_with_variables
    val[:env] = val[:env].map { |k, v| "#{k}=#{v}" }
    val
  end

  def repo_for_minion
    repo.merge(auth_user: auth_username, auth_token: auth_token)
  end

end
