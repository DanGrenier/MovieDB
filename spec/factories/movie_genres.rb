FactoryBot.define do 
  factory :movie_genre do 
    sequence(:name) {|n| "Genre#{n}"}
    association :movie
  end	
end
