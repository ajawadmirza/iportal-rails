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

ActiveRecord::Schema[7.0].define(version: 2022_09_06_102357) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "candidates", force: :cascade do |t|
    t.string "name"
    t.string "cv_url"
    t.string "cv_key"
    t.string "stack"
    t.string "experience_years"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "status"
    t.string "remarks"
    t.string "file_url"
    t.string "file_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "interview_id"
    t.integer "user_id"
    t.index ["interview_id"], name: "index_feedbacks_on_interview_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.string "scheduled_time"
    t.string "location"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "candidate_id"
    t.index ["candidate_id"], name: "index_interviews_on_candidate_id"
  end

  create_table "interviews_users", id: false, force: :cascade do |t|
    t.bigint "interview_id"
    t.bigint "user_id"
    t.index ["interview_id"], name: "index_interviews_users_on_interview_id"
    t.index ["user_id"], name: "index_interviews_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.string "employee_id"
    t.boolean "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
