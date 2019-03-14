FactoryBot.define do 
  factory :user do
    sequence(:login) {|n| "user#{n}@example.com"}
    sequence(:password) {|n| "password#{n}"}

    #Make some users admin	
    trait :admin do 
      admin {true}	
    end
  end
end