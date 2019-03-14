module Api
  module V1
    class AccessTokensController < ApplicationController
      skip_before_action :authorize!, only: :create
      
      def create
   	   	authenticator = UserAuthenticator.new(formatted_params)
      	authenticator.perform
      	render json: authenticator.access_token, status: :created
      end	

      def destroy
      	current_user.access_token.destroy
      end

      private
        def formatted_params
        	authentication_params.to_h.symbolize_keys
        end
        def authentication_params
        	params.dig(:data,:attributes)&.permit(:login,:password)
        end
    end
  end
end