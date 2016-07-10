class Repos::JobsController < ApplicationController

  def create
    render json: @repo.enqueue_job(params[:branch])
  end

  def index
    render json: @repo.jobs.order(id: :desc)
  end

  def show
    render json: @repo.jobs.find(params[:id])
  end

  protected
  def set_repo
    @repo = current_user.repos.find(params[:id])
  end

end
