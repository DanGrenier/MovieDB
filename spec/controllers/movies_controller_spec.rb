require 'rails_helper'

describe Api::V1::MoviesController do 
  describe "#index" do 
    let(:movie1) {create :movie}	
    let(:movie2) {create :movie}	
    subject {get :index, params: {movie_ids: "#{movie1.id},#{movie2.id}"} }
    it "should return a success response" do 
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