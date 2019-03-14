require 'rails_helper'

RSpec.describe MovieScore, type: :model do 
  it "should have a valid factory to test with" do 
  	expect(FactoryBot.build :movie_score).to be_valid
  end

  it "should validate presence of score" do 
  	score = FactoryBot.build :movie_score, score: nil
  	expect(score).not_to be_valid
  end

  it "should not allow duplicate scores from the same user on the same movie" do 
  	score = FactoryBot.create :movie_score
  	second_score = FactoryBot.build :movie_score, user: score.user, movie: score.movie
  	expect(second_score).not_to be_valid
  end

  it "should call the method that calculates average" do 
  	user1 = FactoryBot.create :user
  	user2 = FactoryBot.create :user
  	score = FactoryBot.create :movie_score, user: user1 , score: 100
  	score2 = FactoryBot.create :movie_score, movie: score.movie, user: user2, score: 50
    expect(score.movie.avg_score.to_f).to eq(75.0)
  end

end