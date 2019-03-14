class CreateMovieScores < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_scores do |t|
     	t.references :movie 
    	t.references :user 
    	t.integer :score, null:false 
    	t.datetime :created_at, null:false
    end
  end
end
