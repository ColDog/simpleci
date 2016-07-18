module Api
  class Users::JobsController < ApiController

    def index
      render json: @user.jobs
    end

    def show
      render json: @user.jobs.find(params[:id])
    end

  end
end
