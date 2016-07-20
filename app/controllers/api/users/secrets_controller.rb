module Api
  module Users
    class SecretsController < ApiController
      before_action :set_base_user

      def index
        render json: @user.secrets
      end

      def show
        render json: @user.secrets.find_by!(key: params[:id])
      end

      def create
        render json: @user.secrets.create!(safe_params)
      end

      private
      def safe_params
        params.require(:secret).permit(:key, :value)
      end

    end
  end
end
