class Token < ApplicationRecord
  belongs_to :user

  def self.generate_token(user)
    secret = SecureRandom.hex(32)
    key = SecureRandom.hex(16)

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    digest = BCrypt::Password.create(secret, cost: cost)

    Token.create!(key: key, secret: digest, user_id: user.id)
    {secret: secret, key: key}
  end

  def self.user_from_token(client_id, token)
    db_token = Token.find_by!(key: client_id)
    if db_token && BCrypt::Password.new(db_token.secret).is_password?(token)
      return db_token.user
    end
    nil
  end

end
