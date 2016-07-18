class UsersController < ApplicationController

  def current
    render json: current_user
  end

  def sync
    render json: current_user.sync
  end

  def teams
    render json: current_user.teams
  end

  def index
    render json: current_user.users
  end

  def show
    render json: current_user.users.find(params[:id])
  end

  def destroy
    render json: current_user.users.find(params[:id]).destroy!
  end

end
