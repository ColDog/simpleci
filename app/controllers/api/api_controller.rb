module Api
  class ApiController < ApplicationController
    # before_action :authenticate

    rescue_from(ActiveRecord::RecordInvalid) do |e|
      render json: {error: 422, message: e.message}
    end

    rescue_from(ActiveRecord::RecordNotFound) do |e|
      render json: {error: 404, message: e.message}
    end

    protected
    def authenticate
      unauthorized! unless current_user
    end

    def unauthorized!
      render json: {error: 'Forbidden', status: 403}, status: 403
    end

    def current_user
      # @current_user ||= User.find(session[:user_id]) if session[:user_id]
      @current_user ||= User.first
    end

    private
    def set_base_user
      if params[:account_id] == 'me'
        @user = current_user
      else
        @user = current_user.users.find(params[:account_id])
      end
    end

  end
end
