class Accounts::ConfigsController < ApplicationController
  before_action :set_base

  def create
    render json: @base.configs.create!(safe_params)
  end

  def index
    render json: @base.configs
  end

  def show
    render json: @base.configs.find(params[:id])
  end

  def update
    config = @base.configs.find(params[:id])
    config.update!(safe_params)
    render json: config
  end

  protected

  def safe_params
    params.require(:config).permit!
  end

end
