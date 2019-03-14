require 'spec_helper'

RSpec.describe Movie, type: :model do 
  it 'should have a valid factory to test with' do
  	expect(FactoryBot.build :movie).to be_valid
  end

  it 'should validate the presence of the name' do 
  	movie = FactoryBot.build :movie, name: ''
  	expect(movie).not_to be_valid
  	expect(movie.errors.messages[:name]).to include("can't be blank")
  end

  it 'should validate the presence of the preview url' do 
  	movie = FactoryBot.build :movie, preview_video_url: ''
  	expect(movie).not_to be_valid
  	expect(movie.errors.messages[:preview_video_url]).to include("can't be blank")
  end

  it 'should validate the presence of the runtime' do 
  	movie = FactoryBot.build :movie, runtime: ''
  	expect(movie).not_to be_valid
  	expect(movie.errors.messages[:runtime]).to include("can't be blank")
  end  

  it 'should validate the presence of the synopsis' do 
  	movie = FactoryBot.build :movie, synopsis: ''
  	expect(movie).not_to be_valid
  	expect(movie.errors.messages[:synopsis]).to include("can't be blank")
  end
  it 'should make sure the same movie name cannot be used twice' do
  	movie = FactoryBot.create :movie 
  	movie2 = FactoryBot.build :movie, name: movie.name
  	expect(movie2).not_to be_valid
  end

end