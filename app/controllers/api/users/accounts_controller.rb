module Api
  class Users::AccountsController < ApiController

    def sync
      render json: current_user.sync
    end

    def teams
      render json: current_user.teams
    end

  end
end
