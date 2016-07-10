class ConfigSerializer < ActiveModel::Serializer
  attributes :id, :name, :config, :created_at, :updated_at
end
