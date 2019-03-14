Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 
      #Movies endpoints
      get '/movies' => 'movies#index'
      get '/movies/:id' => 'movies#show'
  	  post '/movies' => 'movies#create'
  	  put '/movies/:id' => 'movies#update'
  	  delete '/movies/:id' => 'movies#destroy'
    end
  end
end
