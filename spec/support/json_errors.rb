require 'rails_helper'

shared_examples_for 'record_not_found' do 
  let(:record_not_found) do 
    {
      "status" => "404",
      "title" => "Record Not Found",
      "detail" => "The specified record was not found"
    }
  end

  it "should return 200 status code" do 
    subject
    expect(response).to have_http_status(:ok)
  end

  it "should return proper error json" do 
    subject
    expect(json['errors']).to include(record_not_found)
  end
end


shared_examples_for 'forbidden_requests' do 
  let(:authorization_error) do
    {
     "status" => "403",
     "source" => { "pointer" => "/headers/authorization" },
      "title" =>  "Not authorized",
      "detail" => "You have no right to access this resource."
    }
  end 

  it "should return 403 status code" do 
    subject
  	expect(response).to have_http_status(:forbidden)
  end

  it "should return proper error json" do 
    subject
   	expect(json['errors']).to include(authorization_error)
  end
end 



shared_examples_for "unauthorized_requests"  do 
  let(:authentication_error) do
    {
      "status" => "401",
      "source" => { "pointer" => "/data/attributes/password" },
      "title" =>  "Invalid login or password",
      "detail" => "You must provide valid credentials in order to exchange them for token."
    }
  end

  it "should return status code 401" do 
    subject
    expect(response).to have_http_status(401)
  end

  it "should return proper error body" do 
    subject
    expect(json['errors']).to include(authentication_error)
  end
end