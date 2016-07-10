class SessionsController < ApplicationController

  def create
    user = User.from_omniauth(auth_hash)
    session[:user_id] = user.id
    render json: user
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
