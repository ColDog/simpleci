class JobsController < ApplicationController

  def update
    render json: Job.find_by!(key: params[:key]).update!(safe_params)
  end

  def poll
    render json: Job.poll
  end

  protected
  def safe_params
    params.require(:job).permit!
  end

end
