class ConfigSerializer < ActiveModel::Serializer
  attributes :id, :name, :body, :body_yaml, :created_at, :updated_at

  def body_yaml
    object.body.to_yaml
  end
end
