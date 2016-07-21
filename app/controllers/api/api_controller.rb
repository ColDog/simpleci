module Api
  class ApiController < ApplicationController
    before_action :authenticate

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
      if @current_user
        return @current_user
      end

      if token
        @current_user = Token.user_from_token(token[0], token[1])
      elsif session[:user_id]
        @current_user = User.find_by(id: session[:user_id])
      end

      @current_user
    end

    def token
      @token ||= request.headers['Authorization'].try(:split, ':')
    end

    private
    def set_base_user
      if params[:user_id] == 'me'
        @user = current_user
      else
        @user = current_user.users.find(params[:user_id])
      end
    end

  end
end
