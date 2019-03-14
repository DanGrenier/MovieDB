Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 
      #Movies endpoints
      get '/movies' => 'movies#index'
      get '/movies/:id' => 'movies#show'
  	  post '/movies' => 'movies#create'
  	  put '/movies/:id' => 'movies#update'
  	  delete '/movies/:id' => 'movies#destroy'

      #Score endpoints
      #Scores endpoints
    post '/movies/:movie_id/scores' =>'movie_scores#create'
    delete '/movies/:movie_id/scores/:id' => 'movie_scores#destroy'
    end
  end
end
