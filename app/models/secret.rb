class Secret < ApplicationRecord
  include EncryptionHelper
  belongs_to :user

  def value=(unencrypted_value)
    self.encrypted_value = encrypt(unencrypted_value)
  end

  def value
    @value ||= decrypt(encrypted_value)
  end

end
