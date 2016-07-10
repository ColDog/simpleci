class Orgs::ReposController < ApplicationController

  def index
    render json: @base.repos
  end

  def show
    render json: @base.repos.find(params[:id])
  end

  def create
    render json: @base.repos.create!(safe_params)
  end

  protected
  def set_base
    if params[:base_id] == 'me'
      @base = current_user
    else
      @base = current_user.teams.find(params[:base_id])
    end
  end

  def safe_params
    params.require(:repo).permit(:name)
  end

end
