class Job < ApplicationRecord
  belongs_to :user
  belongs_to :job_definition

  after_update do
    if self.complete
      Event.emit(user, "jobs:#{state}:#{key}", {
          job_family: job_family,
          job_definition: job_definition.id,
          job: key,
          state: state
      })
    end
  end

  def self.pop(worker)
    return nil if worker.nil?

    Job.where(worker: nil, cancelled: false).limit(1).update(worker: worker).first
  end

  def self.peek
    Job.where(worker: nil, cancelled: false).limit(1).first!
  end

  def self.query(params)
    return all unless params

    scope = all

    scope = scope.where(cancelled: params[:cancelled]) if params[:cancelled]
    scope = scope.where(complete: params[:complete]) if params[:complete]
    scope = scope.where(failed: params[:failed]) if params[:failed]

    scope = scope.joins(:job_definition).where('job_definitions.name': params[:job_family]) if params[:job_family]
    scope = scope.where(job_definition_id: params[:job_definition_id]) if params[:job_definition_id]

    scope
  end

  def job_family
    job_definition.name
  end

  def build
    super.try(:deep_symbolize_keys!)
  end

  def output_url
    if complete
      stored_output_url
    elsif worker.present?
      "#{worker}/current-state"
    end
  end

  def state
    if complete
      if failed
        :failed
      else
        :successful
      end
    elsif cancelled
      :cancelled
    else
      :pending
    end
  end

  def config_body
    repo.config.try(:body)
  end

  def cancel!
    if worker.present?
      minion.cancel
    end
    update!(cancelled: true)
  end

  def minion
    MinionClient.new(worker)
  end

  def owner
    job_definition.user
  end

  def build_for_minion
    val = build
    val[:env] = val[:env].map { |k, v| "#{k}=#{v}" }
    if val[:services]
      val[:services].each do |k, v|
        if v[:env]
          val[:services][k][:env] = val[:services][k][:env].map { |k1, v1| "#{k1}=#{v1}" }
        end
      end
    end
    val
  end

  def repo_for_minion
    repo.merge(auth_user: user.username, auth_token: user.token)
  end

end
