# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_20_000007) do
  create_table "comments", force: :cascade do |t|
    t.integer "comment_id", null: false
    t.bigint "post_id", null: false
    t.bigint "author_id", null: false
    t.text "content", null: false
    t.bigint "parent_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comments_on_comment_id", unique: true
    t.index ["created_at"], name: "index_comments_on_created_at"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "like_id", null: false
    t.bigint "user_id", null: false
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_likes_on_created_at"
    t.index ["like_id"], name: "index_likes_on_like_id", unique: true
    t.index ["target_type", "target_id"], name: "index_likes_on_target_type_and_target_id"
    t.index ["user_id", "target_type", "target_id"], name: "index_likes_on_user_id_and_target_type_and_target_id", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.integer "post_id", null: false
    t.bigint "author_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["post_id"], name: "index_posts_on_post_id", unique: true
  end

  create_table "sprint_participants", force: :cascade do |t|
    t.integer "sprint_participant_id", null: false
    t.bigint "sprint_id", null: false
    t.bigint "user_id", null: false
    t.datetime "join_date"
    t.string "progress_status", default: "not_started"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["join_date"], name: "index_sprint_participants_on_join_date"
    t.index ["progress_status"], name: "index_sprint_participants_on_progress_status"
    t.index ["sprint_id", "user_id"], name: "index_sprint_participants_on_sprint_id_and_user_id", unique: true
    t.index ["sprint_participant_id"], name: "index_sprint_participants_on_sprint_participant_id", unique: true
  end

  create_table "sprints", force: :cascade do |t|
    t.integer "sprint_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_date"], name: "index_sprints_on_end_date"
    t.index ["sprint_id"], name: "index_sprints_on_sprint_id", unique: true
    t.index ["start_date"], name: "index_sprints_on_start_date"
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_id"
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_hash", null: false
    t.datetime "registration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "comments", column: "parent_comment_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "likes", "users"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "sprint_participants", "sprints"
  add_foreign_key "sprint_participants", "users"
end
