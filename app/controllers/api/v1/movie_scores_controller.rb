module Api
  module V1
    class MovieScoresController < ApplicationController
      before_action :load_movie, only: [:create]
      before_action :load_score, only: [:destroy]
    
      def create
  	    @score = @movie.movie_scores
        .build(score_params)
  	    @score.save!
  	    render json: @score, status: :created
      rescue
	      render json: @score,
        adapter: :json_api,
	      serializer: ErrorSerializer,
	      status: :unprocessable_entity
      end

      def destroy
  	    @score.destroy
  	    head :no_content
      end


      private

      def load_movie
	      @movie = Movie.find(params[:movie_id])
      end
 
      def load_score
    	  @score = MovieScore.find(params[:id])
      end  	

      def score_params
  	    params.require(:data).require(:attributes).permit(:score, :user_id)
      end
    end
  end
end