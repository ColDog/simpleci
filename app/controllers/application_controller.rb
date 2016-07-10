class ApplicationController < ActionController::API

  protected
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_base
    if params[:account_id] == 'me'
      @base = current_user
    else
      @base = current_user.teams.find(params[:base_id])
    end
  end

end
