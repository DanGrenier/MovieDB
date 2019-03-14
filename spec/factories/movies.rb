FactoryBot.define do 
  factory :movie do 
    sequence(:name) {|n| "My Movie #{n}"}
    sequence(:preview_video_url) {|n| "https://www.youtube.com/mymovie#{n}"}
    runtime {"1hr 30min"}
    sequence (:synopsis) {|n| "Main plot of the story of My Movie#{n}"}
    avg_score {0.0}
  end
end