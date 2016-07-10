class ApplicationController < ActionController::API
  before_action :authenticate

  protected
  def authenticate
    render json: {error: 'Forbidden', status: 403}, status: 403 unless current_user
  end

  def current_user
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= User.first
  end

  def set_base
    if params[:account_id] == 'me'
      @base = current_user
    else
      @base = current_user.teams.find(params[:base_id])
    end
  end

end
