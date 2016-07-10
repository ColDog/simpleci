class EnqueueJobCommand
  attr_accessor :repo, :user

  def initialize(user, repo)
    @repo = repo
    @user = user
  end

  def run(branch='master')
    jobs = []
    builds.each do |build|
      jobs << enqueue(branch, build)
    end

    {jobs: jobs}
  end

  def enqueue(branch, build)
    next_id = jobs.order(id: :desc).pluck(:job_id).first.try(:+, 1) || 1
    jobs.create!(
        branch: branch,
        job_id: next_id,
        key: "#{repo.name}_#{branch}_#{next_id}",
        build: build,
    )
  end

  def ci_yml
    @ci_yml ||= user.client.ci_yml(repo.name)
  end

  def repo_config
    @repo_config ||= repo.config_body
  end

  def builds
    res = []
    if ci_yml[:builds].present?
      ci_yml[:builds].each do |build|
        res << merge_config(build, repo_config)
      end
    else
      if ci_yml[:build].present?
        res << merge_config(ci_yml[:build], repo_config)
      end
    end

    res
  end

  def merge_config(current, parent)
    return current unless parent

    merge_ary(current, :env, parent)
    merge_ary(current, :pre_test, parent)
    merge_ary(current, :test, parent)
    merge_ary(current, :post_test, parent)
    merge_ary(current, :on_success, parent)
    merge_ary(current, :on_failure, parent)

    current
  end

  protected
  def jobs
    repo.jobs
  end

  def merge_ary(current, key, parent)
    current[key] ||= []
    current[key] = current[key].concat(parent[key]) if parent[key] && parent[key].is_a?(Array)
  end

  def merge_hash(current, key, parent)
    current[key] ||= {}
    current[key] = current[key].merge(parent[key]) if parent[key] && parent[key].is_a?(Hash)
  end

end
