class Api::V1::MovieGenreSerializer < ActiveModel::Serializer
  attributes :id, :name
end