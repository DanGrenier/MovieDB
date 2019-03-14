class Movie < ApplicationRecord
  #Associations
  #Assuming we delete the genres and scores
  #when deleting a movie	
  has_many :movie_genres, dependent: :destroy
  has_many :movie_scores, dependent: :destroy	
  has_many :users, through: :movie_scores
  accepts_nested_attributes_for :movie_genres
  #Validations
  validates :name, presence: true
  validates :name, uniqueness: {message: 'This movie already exists'}
  validates :preview_video_url, presence: true
  validates :runtime, presence: true
  validates :synopsis, presence: true

  #Method that updates a movie score average
  #Called from MovieScore model when a score is added
  #or changed
  def update_score_average
  	avg = self.movie_scores.average('score').to_f || 0.00
  	self.update_columns(avg_score: avg)
  end
  
  #Method that converts the datetime created to seconds
  def created_s
  	created_at.to_i
  end
  
  #Method that converts the datetime updated to seconds
  def updated_s
  	created_at.to_i
  end


end