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

  protected

  def safe_params
    params.require(:repo).permit(:name)
  end

end
