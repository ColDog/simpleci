class Orgs::ConfigsController < ApplicationController
  before_action :set_base

  def create
    render json: @base.configs.create!(safe_params)
  end

  protected
  def set_base
    if params[:base_id] == 'me'
      @base = current_user
    else
      @base = current_user.teams.find(params[:base_id])
    end
  end

  def safe_params
    params.require(:config).permit!
  end

end
