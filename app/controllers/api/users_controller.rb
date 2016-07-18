class UsersController < ApplicationController

  def sync
    render json: current_user.sync
  end

  def teams
    render json: current_user.teams
  end

  def current
    render json: current_user
  end

end
