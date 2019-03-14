Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 

      #User endpoints
      post 'login' => 'access_tokens#create'
      delete 'logout' => 'access_tokens#destroy'
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
