class Minions::JobsController < ApplicationController

  def index
    render json: Job.peek, serializer: JobMinionSerializer
  end

  def create
    render json: Job.pop(params[:worker]), serializer: JobMinionSerializer
  end

  def update
    job = Job.find_by!(key: params[:id])
    job.update!(safe_params)
    render json: job, serializer: JobMinionSerializer
  end

  protected
  def safe_params
    params.permit(:complete, :cancelled, :failed, :failure)
  end

  def authenticate
    unauthorized! unless secret == params[:token]
  end

  def secret
    Rails.application.secrets[:secret_key_base]
  end

end
