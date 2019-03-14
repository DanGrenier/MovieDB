require 'rails_helper'
RSpec.describe User, type: :model do 
  it "should have a valid factory to test with"	do
    expect(build :user).to be_valid
  end

  it "should not allow a duplicate login name" do 
  	user1 = create :user
  	#If we create a user with the same login as user1
  	user2 = build :user, login: user1.login
  	#Its not valid
  	expect(user2).not_to be_valid
  	#However if we setup the login to something else
  	user2.login = "anotherlogin@example.com"
  	#It should be valid
  	expect(user2).to be_valid
  end

end