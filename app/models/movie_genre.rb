class MovieGenre < ApplicationRecord
  #Associations
  belongs_to :movie	
  #Validations
  validates :name, presence: true 
  #duplicate genres cannot be assigned to a single movie
  validates :name, :uniqueness=> {:scope => [:movie_id], :message=> 'This genre has already be assigned to this movie'}
end