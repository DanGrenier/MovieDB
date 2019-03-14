

user1 = User.create(login: "user@example.com", password: "password", admin: false)
user2 = User.create(login: "user2@example.com", password: "password2", admin: false)
admin = User.create(login: "admin@example.com", password: "adminpassword", admin: true)

Movie.new(name: "Star Wars", preview_video_url: "www.youtube.com/starwars", runtime: "1 hr 30 min", synopsis: "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire's world-destroying battle station").tap do |movie|
  movie.movie_genres_attributes = ["Sci-Fi","Action"].map do |genre_name|
  	{name: genre_name}
  end
end.save! do |new_movie1|
  new_movie1.movie_scores.create(score: 80, user: user1)
  new_movie1.movie_scores.create(score: 80, user: user2)
end

Movie.new(name: "Forrest Gump", preview_video_url: "www.youtube.com/forrestgump", runtime: "2 hr 22 min", synopsis: "The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate, and other history unfold through the perspective of an Alabama man with an IQ of 75.").tap do |movie|
  movie.movie_genres_attributes = ["Drama","Comedy-drama","Romance"].map do |genre_name|
  	{name: genre_name}
  end
end.save! do |new_movie|
  new_movie.movie_scores.create(score: 95, user: user1)
end
