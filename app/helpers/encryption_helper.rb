module EncryptionHelper
  ENCRYPTION_KEY = ENV['ENCRYPTION_KEY'] || 'secret'

  def encrypt(value)
    crypt.encrypt_and_sign(value)
  end

  def decrypt(value)
    crypt.decrypt_and_verify(value)
  end

  private
  def crypt
    salt = SecureRandom.random_bytes(64)
    key = ActiveSupport::KeyGenerator.new(ENCRYPTION_KEY).generate_key(salt)
    ActiveSupport::MessageEncryptor.new(key)
  end

end
