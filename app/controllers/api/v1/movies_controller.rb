module Api
  module V1
    class MoviesController < ApplicationController
      before_action :just_for_admin, only: [:create, :update, :destroy]
      before_action :load_movie, only: [:show,:update,:destroy]
    
      def index
        movie_ids = params[:movie_ids].split(",")
	      movies = Movie.where(id: movie_ids).order(:id)
	      render json: movies
      end 

      def show
        render json: @movie  
      end

      def create
        movie = Movie.new(movie_params)
        movie.save!
        render json: movie, status: :created
      rescue
        render json: movie,
        adapter: :json_api,
        serializer: ErrorSerializer,
        status: :unprocessable_entity
      end

      def update
        @movie.update_attributes!(movie_params)
        render json: @movie, status: :ok
      rescue
        render json: @movie,
        adapter: :json_api,
        serializer: ErrorSerializer,
        status: :unprocessable_entity
      end

      def destroy
        @movie.destroy
        head :no_content
      end
      
      private
        def movie_params
	        params.require(:data).require(:attributes).permit(:name,:preview_video_url,:runtime,:synopsis, movie_genres_attributes: [:id,:name])  
        end

        def load_movie
          @movie = Movie.find(params[:id])
        end

        def just_for_admin
          raise AuthorizationError unless current_user.admin
        end


    end
  end
end