class Team < ApplicationRecord
  has_many :members
  has_many :repos
  has_many :configs

  def create_repo(params)
    params[:team_id] = id
    params[:provider] = provider
    Repo.create!(params)
  end

end
