module Api
  class UsersController < ApiController

    def sync
      render json: current_user.sync
    end

    def teams
      render json: current_user.teams
    end

    def index
      render json: current_user.users
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
