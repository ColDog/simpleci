module Api
  class UsersController < ApiController
    before_action :set_base_user, only: [:sync, :teams, :users]

    def sync
      render json: @user.sync
    end

    def teams
      render json: {teams: @user.client.teams}
    end

    def users
      render json: @user.users
    end

    def show
      if params[:id] == 'me'
        render json: current_user
      else
        render json: current_user.users.find(params[:id])
      end
    end

    def destroy
      render json: current_user.users.find(params[:id]).destroy!
    end

  end
end
