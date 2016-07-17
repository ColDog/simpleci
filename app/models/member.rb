class Member < ApplicationRecord
  belongs_to :source, class_name: User
  belongs_to :target, class_name: User
end
