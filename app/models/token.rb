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

end
