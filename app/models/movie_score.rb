class MovieScore < ApplicationRecord
  #Associations
  belongs_to :movie
  belongs_to :user
  #Validations
  validates :score, presence: true
  #Users cannot score the same movie twice
  validates :user_id, :uniqueness => {:scope => [:movie_id,:movie_id], :message => 'You already scored that movie'}

  #After scores are updated or added we update
  #the average score on the references movie
  after_save :update_score_average
  after_destroy :update_score_average
  
  #method that returns the created datetime to seconds
  def created_s
  	created_at.to_i
  end

  def created_ms
    created_at.to_datetime.strftime("%Q")
  end


  #method that is called on the referenced movie
  #in order to update its average score
  def update_score_average
    self.movie.update_score_average
  end




end