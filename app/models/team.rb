class Team < ApplicationRecord
  has_many :members
  has_many :repos
  has_many :configs
end
