class Variable < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :team, optional: true

  attr_accessor :encrypted

  before_validation do
    if encrypted
      self.encrypted_value = encrypt(value)
      self.value = nil
    end
  end

  def get_value
    if encrypted_value.present?
      decrypt(encrypted_value)
    else
      value
    end
  end

end
