class User < ApplicationRecord
  has_many :members
  has_many :teams, through: :members
  has_many :repos
  has_many :configs
  has_many :variables

  def self.from_omniauth(auth)
    find_or_update_by!({provider: auth.provider, uid: auth.uid}, {
        name: auth.info.name, token: auth.credentials.token, email: auth.info.email, username: auth.info.nickname
    })
  end

  def create_repo(params)
    params[:user_id] = id
    params[:provider] = provider
    Repo.create!(params)
  end

  def all_repos
    Repo
        .left_joins(team: [:members])
        .where('members.user_id = ? OR repos.user_id = ?', self.id, self.id)
        .group('repos.id')
  end

  def sync
    client.teams.each do |team|
      unless teams.find_by(name: team[:name])
        team = Team.create!(name: team[:name])
        Member.create!(team_id: team.id, user_id: id)
      end
    end
    teams
  end

  def client
    @client ||= if provider == 'bitbucket'
                  bitbucket
                elsif provider == 'github'
                  github
                end
  end

  def bitbucket
    BitbucketClient.new(token)
  end

  def github
    GithubClient.new(username, token)
  end

end
