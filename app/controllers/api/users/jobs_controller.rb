module Api
  module Users
    class JobsController < ApiController

      def index
        render json: @user.jobs
      end

      def show
        render json: @user.jobs.find_by!(key: params[:id])
      end

      def destroy
        render json: @user.jobs.find_by!(key: params[:id]).cancel
      end

    end
  end
end
