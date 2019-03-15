require 'rails_helper'

describe Api::V1::MovieScoresController do 
  describe "#create" do
    let(:user1) {create :user}
    let(:admin) {create :user, :admin}
    let(:movie) {create :movie}
    subject {post :create, params:{ movie_id: movie.id}}

    context 'when no access token is provided' do 
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid access code provided' do 
      before {request.headers['authorization'] = 'invalid token'}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as admin' do 
      let(:access_token) {create :access_token, user: admin}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as an user' do 
      let(:access_token) {create :access_token, user: user1}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}  
      context "when invalid parameters are provided" do 
        let(:invalid_attributes) do 
          {
            data: {
              type:"movie_score",
              attributes:{
                score: ''
              }
            }
          }
        end

        subject {post :create, params: invalid_attributes.merge(movie_id: movie.id)}

        it "should have a 422 status code" do 
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return proper error" do 
          subject
          expect(json['errors']).to include(
          {
            "source" => {"pointer"=>"/data/attributes/score"},
            "detail" => "can't be blank"
          })
        end
      end 

      context "when valid parameters are provided" do 
        let(:valid_attributes) do 
          {
            "data"=>{
              "type"=>"movie_score",
              "attributes"=>{
                "score"=> 75
              }
            }
          }
        end

        subject {post :create, params: valid_attributes.merge(movie_id: movie.id)}

        it "should have a 201 status code" do 
          subject
          expect(response).to have_http_status(:created)
        end

        it "should have created the score for that movie" do 
          expect{subject}.to change(movie.movie_scores,:count).by(1)
        end        
        
      end

      context "when trying to create a score for the same movie again" do 
        let(:score) {create :movie_score, user: user1, movie: movie}     	

        let(:valid_attributes) do 
          {
            "data"=>{
              "type"=>"movie",
              "attributes"=>{
                "score"=> 75
              }
            }
          }
        end

        subject {post :create, params: valid_attributes.merge(movie_id: movie.id)}

        it "should have a 422 status code" do 
          score	
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should not have created the score" do 
          #Call the movie before to create it
          #Otherwise when calling subject, it would create the 
          #article and then try to add it again... not changing the count  
          score
          expect{subject}.to_not change{movie.movie_scores.count}
        end        

        it "should return proper error" do 
        	score
          subject
          expect(json['errors']).to include(
          {
            "source" => {"pointer"=>"/data/attributes/user_id"},
            "detail" => "You already scored that movie"
          })
        end
      end
    end
  end

  describe "#destroy" do 
  	let(:user1) {create :user}
  	let(:user2) {create :user}
  	let(:admin) {create :user, :admin}
  	let(:access_token1) {create :access_token, user: user1}
  	let(:access_token2) {create :access_token, user: user2}
  	let(:access_token_admin) {create :access_token, user: admin}
    let(:movie) {create :movie}
    let(:score_user1) {create :movie_score, user: user1, movie: movie}
    let(:score_user2) {create :movie_score, user: user2, movie: movie}
    subject {delete :destroy, params: { id: score_user1.id, movie_id: movie.id}}

    context 'when no access token is provided' do 
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid access code provided' do 
      before {request.headers['authorization'] = 'invalid token'}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as user' do 
   	  context 'when trying to delete own score' do
    	before {request.headers['authorization'] = "Bearer #{access_token1.token}"}
    	subject {delete :destroy, params: { id: score_user1.id, movie_id: movie.id}} 

        it "should have a 204 status code" do 
      	  subject
      	  expect(response).to have_http_status(:no_content)
        end

        it "should render empty json" do 
      	  subject
      	  expect(response.body).to be_blank
        end
      
        it "should destroy the score" do 
      	  score_user1
      	  expect{subject}.to change{movie.movie_scores.count}.by(-1)
        end	
      end

      context 'when trying to delete someone else score' do
    	before {request.headers['authorization'] = "Bearer #{access_token1.token}"}
    	subject {delete :destroy, params: { id: score_user2.id, movie_id: movie.id}} 

        it_behaves_like 'forbidden_requests'
      end
    end

    context 'when authenticated as admin' do 
   	  context 'when trying to a user score' do
    	before {request.headers['authorization'] = "Bearer #{access_token_admin.token}"}
    	subject {delete :destroy, params: { id: score_user1.id, movie_id: movie.id}} 

        it "should have a 204 status code" do 
      	  subject
      	  expect(response).to have_http_status(:no_content)
        end

        it "should render empty json" do 
      	  subject
      	  expect(response.body).to be_blank
        end
      
        it "should destroy the score" do 
      	  score_user1
      	  expect{subject}.to change{movie.movie_scores.count}.by(-1)
        end	
      end

          end

  end
end