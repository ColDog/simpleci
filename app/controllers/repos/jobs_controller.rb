class Repos::JobsController < ApplicationController

  def index
    render json: @repo.jobs.order(id: :desc)
  end

  def create
    render json: @repo.enqueue_job(params[:branch])
  end

  def show
    render json: @repo.jobs.find(params[:id])
  end

  def destroy
    render json: @repo.jobs.find(params[:id]).cancel
  end

  def output
    render json: {job_output: @repo.jobs.find(params[:job_id]).output}
  end

  protected
  def set_repo
    @repo = current_user.repos.find(params[:id])
  end

end
