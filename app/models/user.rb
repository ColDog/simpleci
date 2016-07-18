class User < ApplicationRecord
  has_many :members
  has_many :events
  has_many :job_definitions
  has_many :jobs, through: :job_definitions

  def self.from_omniauth(auth)
    find_or_update_by!({provider: auth.provider, uid: auth.uid}, {
        name: auth.info.name, token: auth.credentials.token, email: auth.info.email, username: auth.info.nickname
    })
  end

  # returns self plus all users that are connected through the members table
  def users
    User
        .all
        .joins('LEFT JOIN members on members.target_id = users.id')
        .where('users.id = ? OR members.source_id = ?', id, id)
  end

  def sync
    client.teams.each do |team|
      team = User.find_or_create_by!(username: team[:name], uid: team[:id])
      Member.find_or_create_by!(source_id: id, target_id: team.id)
    end
    users
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
