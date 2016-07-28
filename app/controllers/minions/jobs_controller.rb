class Minions::JobsController < ApplicationController
  before_action :authenticate

  def index
    render json: Job.peek, serializer: JobMinionSerializer
  end

  def create
    job = Job.pop(params[:worker])
    if job
      render json: job, serializer: JobMinionSerializer
    else
      render json: {error: 'No Job Found'}, status: :not_found
    end
  end

  def update
    job = Job.find_by!(key: params[:id])
    job.update!(safe_params)
    render json: job, serializer: JobMinionSerializer
  end

  protected
  def safe_params
    params.permit(:complete, :cancelled, :failed, :failure, :info, :stored_output_url)
  end

end
