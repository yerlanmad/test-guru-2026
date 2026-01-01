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

ActiveRecord::Schema[8.1].define(version: 2025_12_31_150332) do
  create_table "answers", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.boolean "is_correct", default: false, null: false
    t.integer "position", default: 1, null: false
    t.integer "question_id", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "is_correct"], name: "index_answers_on_question_id_and_is_correct"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_categories_on_title", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "points", default: 1, null: false
    t.integer "position", default: 1, null: false
    t.string "question_type", default: "single_choice", null: false
    t.integer "test_id", null: false
    t.datetime "updated_at", null: false
    t.index ["test_id", "position"], name: "index_questions_on_test_id_and_position"
    t.index ["test_id"], name: "index_questions_on_test_id"
  end

  create_table "test_results", force: :cascade do |t|
    t.datetime "completed_at"
    t.integer "correct_answers", default: 0, null: false
    t.datetime "created_at", null: false
    t.decimal "score", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "started_at", null: false
    t.string "status", default: "in_progress", null: false
    t.integer "test_id", null: false
    t.integer "time_spent"
    t.integer "total_questions", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["created_at"], name: "index_test_results_on_created_at"
    t.index ["score"], name: "index_test_results_on_score"
    t.index ["status"], name: "index_test_results_on_status"
    t.index ["test_id"], name: "index_test_results_on_test_id"
    t.index ["user_id", "test_id"], name: "index_test_results_on_user_id_and_test_id"
    t.index ["user_id"], name: "index_test_results_on_user_id"
  end

  create_table "tests", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "level", default: 1, null: false
    t.integer "passing_score", default: 70, null: false
    t.boolean "published", default: false, null: false
    t.integer "time_limit"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_tests_on_author_id"
    t.index ["category_id"], name: "index_tests_on_category_id"
    t.index ["level"], name: "index_tests_on_level"
    t.index ["published"], name: "index_tests_on_published"
    t.index ["title", "category_id"], name: "index_tests_on_title_and_category_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "password_digest", null: false
    t.string "role", default: "student", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_sign_in_at"], name: "index_users_on_last_sign_in_at"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "questions", "tests"
  add_foreign_key "test_results", "tests"
  add_foreign_key "test_results", "users"
  add_foreign_key "tests", "categories"
  add_foreign_key "tests", "users", column: "author_id"
end
