class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :name, null:false
      t.string :preview_video_url, null:false
      t.string :runtime, null:false
      t.text :synopsis, null:false
      t.decimal :avg_score, precision: 5, scale: 1, default:0.0
      t.timestamps
    end
  end
end
