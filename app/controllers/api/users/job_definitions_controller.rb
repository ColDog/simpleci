module Api
  module Users
    class JobDefinitionsController < ApiController
      before_action :set_base_user

      def index
        render json: @user.job_definitions
      end

      def show
        render json: @user.job_definitions.find_by!(name: params[:id])
      end

      def create
        render json: @user.job_definitions.find_or_update_by!({name: safe_params[:name]}, safe_params)
      end

      def update
        create
      end

      private
      def safe_params
        params.require(:job_definition).permit!
      end

    end
  end
end
