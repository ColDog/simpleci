module EncryptionHelper
  ENCRYPTION_KEY = ENV['ENCRYPTION_KEY'] || 'secret'

  def encrypt(value)
    salt = SecureRandom.hex(16)
    secure = crypt(salt).encrypt_and_sign(value)
    "#{salt}*#{secure}"
  end

  def decrypt(value)
    spl = value.split('*')
    crypt(spl[0]).decrypt_and_verify(spl[1])
  end

  private
  def crypt(salt)
    key = ActiveSupport::KeyGenerator.new(ENCRYPTION_KEY).generate_key(salt)
    ActiveSupport::MessageEncryptor.new(key)
  end

end
