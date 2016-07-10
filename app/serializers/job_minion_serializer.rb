class JobMinionSerializer < ActiveModel::Serializer
  attributes :id, :key, :build, :repo
end
