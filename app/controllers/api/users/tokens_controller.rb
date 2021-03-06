module Api
  module Users
    class TokensController < ApiController
      before_action :set_base_user

      def index
        render json: @user.tokens
      end

      def create
        render json: {token: Token.generate_token(@user)}
      end

      def destroy
        render json: @user.tokens.find_by!(key: params[:id]).destroy!
      end

    end
  end
end
