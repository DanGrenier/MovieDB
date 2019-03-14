require 'rails_helper'

require 'rails_helper'
RSpec.describe MovieGenre, type: :model do 
  it "should have a valid factory to test with" do 
  	expect(FactoryBot.build :movie_genre).to be_valid
  end

  it "should validate presence of genre name" do 
  	genre = FactoryBot.build :movie_genre, name: ''
  	expect(genre).not_to be_valid
  end

  it "should not allow duplicate genre for same movie" do 
  	genre = FactoryBot.create :movie_genre
  	second_genre = FactoryBot.build :movie_genre, name: genre.name , movie: genre.movie
  	expect(second_genre).not_to be_valid
  	second_genre.name = 'Some other genre'
  	expect(second_genre).to be_valid
  end
	
end