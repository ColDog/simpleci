class UsersController < ApplicationController

  def current

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
