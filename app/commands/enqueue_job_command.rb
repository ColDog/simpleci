class EnqueueJobCommand
  attr_accessor :job_def, :user

  def initialize(user, job_def)
    @user = user
    @job_def = job_def
  end

  def run(payload)
    branch = payload[:branch] || 'master'

    Job.transaction do
      next_id = job_def.jobs.order(id: :desc).pluck(:job_id).first.try(:+, 1) || 1
      builds.each_with_index.map { |build, idx| enqueue(branch, build, next_id, idx) }
    end
  end

  def enqueue(branch, build, next_id, idx)
    job_def.jobs.create!(
        repo: job_def.repo.merge(branch: branch),
        job_id: next_id,
        key: "#{job_def.name}_#{branch.gsub('/', '-')}_#{next_id}-#{idx}",
        build: build,
        user_id: user.id,
    )
  end

  def ci_yml
    @ci_yml ||= user.client.ci_yml(job_def.repo_name)
  end

  # repo config build to merge into the project configuration
  def definition_build
    @def_build ||= (job_def.build.try(:[], :build) || {})
  end

  # the array of builds to pass through, this handles building up a list of builds to pass through and
  # appropriately merging in the parameters.
  def builds
    return @builds if @builds

    @builds = []
    if ci_yml
      if ci_yml[:builds].present? && ci_yml[:builds].is_a?(Array)
        ci_yml[:builds].each do |build|
          @builds << merge_build(build, definition_build)
        end
      else
        if ci_yml[:build].present? && ci_yml[:build].is_a?(Hash)
          @builds << merge_build(ci_yml[:build], definition_build)
        end
      end
    elsif definition_build.present?
      @builds << definition_build
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
        base_image: main[:base_image] || config[:base_image] || 'ubuntu',
        env: (main[:env] || {}).merge(config[:env] || {}),
        before: main[:pre_test] || config[:pre_test] || [],
        main: main[:test] || config[:test] || [],
        after: main[:post_test] || config[:post_test] || [],
        on_success: main[:on_success] || config[:on_success] || [],
        on_failure: main[:on_failure] || config[:on_failure] || [],
    }
  end

end
