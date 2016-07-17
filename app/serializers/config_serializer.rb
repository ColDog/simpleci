class ConfigSerializer < ActiveModel::Serializer
  cache
  attributes :id, :name, :body, :body_yaml, :created_at, :updated_at

  def body_yaml
    object.body.to_yaml
  end
end
