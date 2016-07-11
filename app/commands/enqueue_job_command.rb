class EnqueueJobCommand
  attr_accessor :repo, :user

  def initialize(user, repo)
    @repo = repo
    @user = user
  end

  def run(branch='master')
    Job.transaction do
      builds.map { |build| enqueue(branch, build) }
    end
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

  # repo config build to merge into the project configuration
  def repo_config_build
    @repo_config ||= repo.config_body.try(:[], :build) || {}
  end

  # the array of builds to pass through, this handles building up a list of builds to pass through and
  # appropriately merging in the parameters.
  def builds
    return @builds if @builds

    @builds = []
    if ci_yml
      if ci_yml[:builds].present? && ci_yml[:builds].is_a?(Array)
        ci_yml[:builds].each do |build|
          @builds << merge_build(build, repo_config_build)
        end
      else
        if ci_yml[:build].present? && ci_yml[:build].is_a?(Hash)
          @builds << merge_build(ci_yml[:build], repo_config_build)
        end
      end
    elsif repo_config_build.present?
      @builds << repo_config_build
    end

    @builds
  end

  # merged build attributes
  # - base_image    -> in repo config overrides main
  # - env           -> variables are merged together, main takes precedence
  # - pre_test      -> if present, main, else default
  # - test          -> if present, main, else default
  # - post_test     -> if present, main, else default
  # - on_success    -> if present, main, else default
  # - on_failure    -> if present, main, else default
  def merge_build(main, config)
    {
        base_image: main[:base_image] || config[:base_image],
        env: (main[:env] || {}).merge(config[:env] || {}),
        pre_test: main[:pre_test] || config[:pre_test],
        test: main[:test] || config[:test],
        post_test: main[:post_test] || config[:post_test],
        on_success: main[:on_success] || config[:on_success],
        on_failure: main[:on_failure] || config[:on_failure],
    }
  end

end
