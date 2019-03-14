# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_14_203233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.bigint "movie_id"
    t.string "name"
    t.index ["movie_id"], name: "index_movie_genres_on_movie_id"
  end

  create_table "movie_scores", force: :cascade do |t|
    t.bigint "movie_id"
    t.bigint "user_id"
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.index ["movie_id"], name: "index_movie_scores_on_movie_id"
    t.index ["user_id"], name: "index_movie_scores_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "name", null: false
    t.string "preview_video_url", null: false
    t.string "runtime", null: false
    t.text "synopsis", null: false
    t.decimal "avg_score", precision: 5, scale: 1, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "login", null: false
    t.string "encrypted_password", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login"
  end

  add_foreign_key "access_tokens", "users"
end
