module Api
  class Users::EventsController < ApiController
    before_action :set_base_user

    def index
      render json: @user.events
    end

    def show
      render json: @user.events.find(params[:id])
    end

    def create
      render json: @user.events.create!(safe_params)
    end

    private
    def safe_params
      params.require(:event).permit!
    end

  end
end
