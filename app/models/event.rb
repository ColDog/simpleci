class Event < ApplicationRecord
  belongs_to :user

  def self.emit(user, name, payload={})
    Event.create!(name: name, user_id: user.id, payload: payload)
  end

end
