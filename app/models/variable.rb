class Variable < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :team, optional: true

  attr_accessor :encrypted

  before_validation do
    if encrypted
      self.encrypted_value = encrypt(value)
    end
  end

  def value
    if encrypted_value.present?
      decrypt(value)
    else
      super
    end
  end

end
