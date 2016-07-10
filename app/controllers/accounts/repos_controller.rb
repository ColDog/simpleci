class Accounts::ReposController < ApplicationController
  before_action :set_base

  def index
    render json: @base.repos
  end

  def show
    render json: @base.repos.find(params[:id])
  end

  def create
    render json: @base.create_repo(safe_params)
  end

  def update
    repo = @base.repos.find(params[:id])
    repo.update!(safe_params)
    render json: repo
  end

  protected

  def safe_params
    params.require(:repo).permit(:name, :config_id)
  end

end
