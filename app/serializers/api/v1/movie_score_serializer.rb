class Api::V1::MovieScoreSerializer < ActiveModel::Serializer
attributes :id, :score, :user_id
attribute :created_s, key: 'created_at'
end