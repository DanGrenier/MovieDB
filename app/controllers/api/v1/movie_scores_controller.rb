module Api
  module V1
    class MovieScoresController < ApplicationController
      before_action :not_for_admin
      before_action :load_movie, only: [:create]
      before_action :load_score, only: [:destroy]
    
      def create
  	    @score = @movie.movie_scores
        .build(score_params.merge(user: current_user))
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
  	    params.require(:data).require(:attributes).permit(:score)
      end

      def not_for_admin
        raise AuthorizationError unless !current_user.admin
      end 

      def only_delete_your_score
        raise AuthorizationError unless @score.user == current_user
      end   
    end
  end
end