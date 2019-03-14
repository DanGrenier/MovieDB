class MovieSerializer < ActiveModel::Serializer
  attributes :id, :name, :preview_video_url, :runtime, :synopsis
  attribute :created_s, key: 'created_at'
  attribute :updated_s, key: 'updated_at'
  attribute :genres 

  def genres
    object.movie_genres.map do |genre| 
      ::MovieGenreSerializer.new(genre).attributes
    end
  end

  attribute :avg_score
  attribute :most_recent_scores

  def most_recent_scores
	object.movie_scores.map do |score|
      ::MovieScoreSerializer.new(score).attributes
  end

end