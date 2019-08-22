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
  #Scopes
  scope :with_ids, -> (movie_ids) {where(id: movie_ids).order(:id) }
  scope :all_ordered, -> {order(:id)}
  scope :with_min_score, -> (score) {where('avg_score >= ?',score).order(:id)}
  alias_attribute  :genres , :movie_genres_attributes
  #Method that updates a movie score average
  #Called from MovieScore model when a score is added
  #or changed

  def most_recent_scores
    self.movie_scores.order('created_at DESC').limit(10)
  end
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


  def created_ms
    created_at.to_datetime.strftime("%Q")
  end

  def updated_ms
    updated_at.to_datetime.strftime("%Q")
  end


end