class Config < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :team, optional: true

  before_validation do
    if self.body.is_a?(String)
      self.body = YAML.load(body)
    elsif self.body.is_a?(NilClass)
      self.body = {}
    end
  end

  validate { errors.add(:body, 'Must be a hash') unless body.is_a?(Hash) }

end
