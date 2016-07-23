module Api
  class ApiController < ApplicationController
    before_action :authenticate

    rescue_from(ActiveRecord::RecordInvalid) do |e|
      render json: {error: 422, message: e.message}
    end

    rescue_from(ActiveRecord::RecordNotFound) do |e|
      render json: {error: 404, message: e.message}
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
