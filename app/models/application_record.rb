class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_or_update_by!(hash, updates={}, &block)
    rec = find_or_initialize_by(hash)
    rec.assign_attributes(updates)
    if rec.new_record?
      block.call(rec) if block
    end
    rec.save!
    rec
  end

end
