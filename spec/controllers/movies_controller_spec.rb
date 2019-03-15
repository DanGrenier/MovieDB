require 'rails_helper'

describe Api::V1::MoviesController do 
  describe "#index" do 
    let(:movie1) {create :movie}	
    let(:movie2) {create :movie}	
    subject {get :index}
    
    context 'when no access token is provided' do 
      it_behaves_like 'forbidden_requests'
    end

     context 'when invalid access token provided' do 
      before {request.headers['authorization'] = 'invalid token'}
      it_behaves_like 'forbidden_requests'
    end


    context 'when authenticated' do 
      let(:access_token) {create :access_token}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}
      context 'when invalid parameters provided' do
        let(:invalid_params) do 
          {bad_tag: "1,2,3,4"}
        end
        
        subject {get :index, params: {bad_tag:"1,2,3,4"}}
        

        it "should return an OK status code" do 
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should return proper json" do 
          subject
          expect(json['errors']).to include(
            {
              "title" => "Please provide proper parameters",
              "detail" => "Please provide a list of movie ids comma delimited under a movie_ids parameter",
              "status" => "422"
            })

        end
      end 
      
      context "when success request sent" do
        let(:access_token) {create :access_token}

        before {request.headers['authorization'] = "Bearer #{access_token.token}"}

        let(:valid_params) do 
          {movie_ids: "#{movie1.id},#{movie2.id}"}
        end
        
        subject {get :index, params: valid_params}

        it "should have proper status code" do 
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should return proper json" do 
          subject
          Movie.all.each_with_index do |movie,index|
      	  expect(json_data[index]['attributes']).to eq(
      		 {"name" => movie.name,
      		 "avg_score" => movie.avg_score.to_s,	
      		 "preview_video_url" => movie.preview_video_url,
      		 "runtime" => movie.runtime,
      		 "synopsis" => movie.synopsis,
      		 "created_at" => movie.created_s,
      		 "updated_at" => movie.updated_s,
      		 "genres" => movie.movie_genres,
      		 "most_recent_scores" => movie.movie_scores})
          end
        end
      end
    end  
  end
  
  describe "#show" do 
    let(:movie) {create :movie}
    subject {get :show, params: {id: movie.id}}

    context 'when no access token is provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid access token provided' do 
      before {request.headers['authorization'] = 'invalid token'}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated' do
      let(:access_token) {create :access_token}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}
      
      subject {get :show, params: {id: movie.id}}

      it "should return a success response" do 
        subject
        expect(response).to have_http_status(:ok)
      end

      it "sould render proper json" do 
        subject
        expect(json_data['attributes']).to eq(
          {"name" => movie.name,
           "avg_score" => movie.avg_score.to_s, 
           "preview_video_url" => movie.preview_video_url,
           "runtime" => movie.runtime,
           "synopsis" => movie.synopsis,
           "created_at" => movie.created_s,
           "updated_at" => movie.updated_s,
           "genres" => movie.movie_genres,
           "most_recent_scores" => movie.movie_scores
           })
      end  
    end
  end

  describe "#create" do 
    let(:user1) {create :user}
    let(:admin) {create :user, :admin}
    subject {post :create}

    context 'when no access token is provided' do 
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid access code provided' do 
      before {request.headers['authorization'] = 'invalid token'}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as user' do 
      let(:access_token) {create :access_token, user: user1}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as an admin' do 
      let(:access_token) {create :access_token, user: admin}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}  
      context "when invalid parameters are provided" do 
        let(:invalid_attributes) do 
          {
            data: {
              type:"movie",
              attributes:{
                name: '',
                preview_video_url:'',
                runtime: '',
                synopsis: '',
                genres: []
              }
            }
          }
        end

        subject {post :create, params: invalid_attributes}

        it "should have a 422 status code" do 
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return proper error" do 
          subject
          expect(json['errors']).to include(
          {
            "source" => {"pointer"=>"/data/attributes/name"},
            "detail" => "can't be blank"
          },
          {
            "source" => {"pointer"=>"/data/attributes/preview_video_url"},
            "detail" => "can't be blank"
          },
          {
            "source" => {"pointer"=>"/data/attributes/runtime"},
            "detail" => "can't be blank"
          },
          {
            "source" => {"pointer"=>"/data/attributes/synopsis"},
            "detail" => "can't be blank"
          }
          )
        end
      end 

      context "when valid parameters are provided" do 
        let(:valid_attributes) do 
          {
            "data"=>{
              "type"=>"movie",
              "attributes"=>{
                "name"=> 'My Super Movie',
                "preview_video_url"=>'https://www.youtube.com/mysupermovie',
                "runtime"=> '1 h 55 m',
                "synopsis"=> 'An awesome super movie',
                "genres"=>  [{"name"=> "Drama"},{"name" => "Romance"}]
              }
            }
          }
        end

        subject {post :create, params: valid_attributes}

        it "should have a 201 status code" do 
          subject
          expect(response).to have_http_status(:created)
        end

        it "should have created the movie" do 
          expect{subject}.to change{Movie.count}.by(1)
        end        

        it "should have created the genres" do 
          expect{subject}.to change{MovieGenre.count}.by(2)
        end
      end

      context "when trying to create a movie that already exists" do 
        let(:movie) {create :movie}
        let(:valid_attributes) do 
          {
            "data"=>{
              "type"=>"movie",
              "attributes"=>{
                "name"=> movie.name,
                "preview_video_url"=>'https://www.youtube.com/mysupermovie',
                "runtime"=> '1 h 55 m',
                "synopsis"=> 'An awesome super movie',
                "genres"=>  [{"name"=> "Drama"},{"name" => "Romance"}]
              }
            }
          }
        end

        subject {post :create, params: valid_attributes}

        it "should have a 422 status code" do 
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should render proper json error" do
          subject
          expect(json['errors']).to include(
          {
            "source" => {"pointer"=>"/data/attributes/name"},
            "detail" => "This movie already exists"
          }) 
        end

        it "should not have created the movie" do 
          #Call the movie before to create it
          #Otherwise when calling subject, it would create the 
          #article and then try to add it again... not changing the count  
          movie
          expect{subject}.to_not change{Movie.count}
        end        

        it "should not have created the genres" do 
          expect{subject}.to_not change{MovieGenre.count}
        end
      end
    end
  end

  describe "#put" do 
    let(:user1) {create :user}
    let(:admin) {create :user, :admin}
    let(:movie) {create :movie}
    subject {patch :update, params:{id: movie.id}}

    context 'when no access token is provided' do 
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid access code provided' do 
      before {request.headers['authorization'] = 'invalid token'}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as user' do 
      let(:access_token) {create :access_token, user: user1}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as an admin' do 
      let(:access_token) {create :access_token, user: admin}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}  
      context "when invalid parameters are provided" do 
        let(:invalid_attributes) do 
          {
            data: {
              type:"movie",
              attributes:{
                name: '',
                preview_video_url:'',
                runtime: '',
                synopsis: '',
                genres: []
              }
            }
          }
        end

        subject do 
          patch :update, params: invalid_attributes.merge(id: movie.id)
        end

        it "should have a 422 status code" do 
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return proper error" do 
          subject
          expect(json['errors']).to include(
          {
            "source" => {"pointer"=>"/data/attributes/name"},
            "detail" => "can't be blank"
          },
          {
            "source" => {"pointer"=>"/data/attributes/preview_video_url"},
            "detail" => "can't be blank"
          },
          {
            "source" => {"pointer"=>"/data/attributes/runtime"},
            "detail" => "can't be blank"
          },
          {
            "source" => {"pointer"=>"/data/attributes/synopsis"},
            "detail" => "can't be blank"
          }
          )
        end
      end 

      context "when valid parameters are provided" do 
        let(:valid_attributes) do 
          {
            "data"=>{
              "type"=>"movie",
              "attributes"=>{
                "name"=> 'My New Title',
                "preview_video_url"=>'https://www.youtube.com/mysupermovie',
                "runtime"=> '1 h 55 m',
                "synopsis"=> 'An awesome super movie',
                "genres"=>  [{"name"=> "Drama"},{"name" => "Romance"}]
              }
            }
          }
        end

        subject do
          patch :update, params: valid_attributes.merge(id: movie.id)
        end

        it "should have a 200 status code" do 
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should have updated the movie" do 
          subject
          expect(movie.reload.name).to eq(valid_attributes['data']['attributes']['name'])
        end        
      end
    end

  end

  describe "#destroy" do
    let(:user1) {create :user}
    let(:admin) {create :user, :admin}
    let(:movie) {create :movie}
    
    subject {delete :destroy, params:{id: movie.id}}

    context 'when no code provided' do 
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do 
      before {request.headers['authorization'] = 'Invalid token'}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as user' do 
      let(:access_token) {create :access_token, user: user1}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}
      it_behaves_like 'forbidden_requests'
    end

    context 'when authenticated as an admin' do 
      let(:access_token) {create :access_token, user: admin}
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}  
      
      context "With invalid movie id" do 
        subject {delete :destroy, params:{id: -1}}
        it_behaves_like 'record_not_found'
      end

      context "With valid movie id" do 
        it "should have a 204 status code" do
          subject
          expect(response).to have_http_status(:no_content)
        end

        it "should have empty json body" do 
          subject
          expect(response.body).to be_blank
        end

        it "should destroy the movie" do
        #Call the movie before to create it
        #Otherwise when calling subject, it would create the 
        #article and then destroy it... not changing the count  
        movie
        expect{subject}.to change{Movie.count}.by(-1)
        end
      end
    end
  end
end