class SecretSerializer < ActiveModel::Serializer
  attributes :key, :value
end
