class Repos::InfoController < ApplicationController
  before_action :set_repo

  def branches
    render json: {branches: current_user.client.branches(@repo.name)}
  end

  protected
  def set_repo
    @repo = current_user.repos.find(params[:repo_id])
  end

end
