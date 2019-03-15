class Api::V1::MovieSerializer < ActiveModel::Serializer
  attributes :id, :name, :preview_video_url, :runtime, :synopsis
  attribute :created_s, key: 'created_at'
  attribute :updated_s, key: 'updated_at'
  attribute :avg_score
  attribute :movie_genres, key: 'genres', serializer: Api::V1::MovieGenreSerializer
  attribute :most_recent_scores,  serializer: Api::V1::MovieScoreSerializer
end