class User < ApplicationRecord
  has_many :members
  has_many :users, through: :members

  def self.from_omniauth(auth)
    find_or_update_by!({provider: auth.provider, uid: auth.uid}, {
        name: auth.info.name, token: auth.credentials.token, email: auth.info.email, username: auth.info.nickname
    })
  end

  def sync
    client.teams.each do |team|
      unless teams.find_by(name: team[:name])
        team = User.create!(username: team[:name], uid: team[:id])
        Member.create!(source_id: team.id, target_id: id)
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
