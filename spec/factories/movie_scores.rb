FactoryBot.define do 
  factory :movie_score do 
    association :movie 
	association :user
	score {75}
  end
end