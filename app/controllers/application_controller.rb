class ApplicationController < ActionController::API
  class AuthorizationError < StandardError;end
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  private 
   before_action :authorize!


  def authorize!
  	raise AuthorizationError unless current_user
  end

  def access_token
  	provided_token = request.authorization&.gsub(/\ABearer\s/,'')
  	@access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user 
  end
  
  def authentication_error
  	error={
      "status" => "401",
  	  "source" => {"pointer" => "/password"},
  	  "title" => "Invalid Login or Password",
  	  "detail" => "Your must provide valid credentials in order to exchange for token"
  	}
  	render json: {"errors":[error]}, status: 401
  end

  def authorization_error
  	error = {
  	  "status" => "403",
  	  "source" => {"pointer" => "/headers/authorization"},
  	  "title" =>  "Not authorized",
      "detail" => "You have no right to access this resource."
    }
    render json: {"errors": [error]}, status: 403
  end

  def parameter_error
    error = {
      "status" => "422",
      "title" => "Please provide proper parameters",
      "detail" => "Please provide a list of movie ids comma delimited under a movie_ids parameter"
    }
    render json: {"errors":[error], status: :unprocessable_entity}
  end

  def not_found_error
  	error = {
  		"status" => "404",
  		"title" => "Record Not Found",
  		"detail" => "The specified record was not found"
  	}
  	render json: {"errors":[error], status: :not_found}
  end



end
