class UserAuthenticator
  class AuthenticationError < StandardError; end
  attr_reader :access_token, :user

  def initialize(login: nil, password: nil)
    @login = login
    @password = password	
  end

  def perform
	raise AuthenticationError if (login.blank? || password.blank?)
	raise AuthenticationError unless User.exists?(login: login)
	user = User.find_by(login: login)
	raise AuthenticationError unless user.password == password
	@user = user

	set_access_token
  end

  def user
    @user
  end


  private 
    attr_reader :login, :password

    def set_access_token
      @access_token = if user.access_token.present?
        user.access_token
      else
  	    user.create_access_token
      end
    end
end