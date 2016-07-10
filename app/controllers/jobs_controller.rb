class JobsController < ApplicationController

  def create
    render json: Job.poll
  end

  def update
    job = Job.find_by!(key: params[:id])
    job.update!(safe_params)
    render json: job
  end

  protected
  def safe_params
    params.require(:job).permit!
  end

end
