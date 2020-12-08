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

ActiveRecord::Schema.define(version: 2020_03_31_141658) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 0
  end

  create_table "cover_pictures", force: :cascade do |t|
    t.boolean "current", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "dangers", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.boolean "adhoc", default: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.integer "experiment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.index ["experiment_id"], name: "index_documents_on_experiment_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "inventory_nr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "adhoc", default: false
  end

  create_table "experiment_danger_assignments", force: :cascade do |t|
    t.integer "danger_id"
    t.integer "experiment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["danger_id"], name: "index_experiment_danger_assignments_on_danger_id"
    t.index ["experiment_id"], name: "index_experiment_danger_assignments_on_experiment_id"
  end

  create_table "experiment_equipment_assignments", force: :cascade do |t|
    t.integer "equipment_id"
    t.integer "experiment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number", default: 1
    t.index ["equipment_id"], name: "index_experiment_equipment_assignments_on_equipment_id"
    t.index ["experiment_id"], name: "index_experiment_equipment_assignments_on_experiment_id"
  end

  create_table "experiments", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.integer "sub_category_id"
    t.text "description"
    t.boolean "deleted", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "message"
    t.index ["sub_category_id"], name: "index_experiments_on_sub_category_id"
    t.index ["user_id"], name: "index_experiments_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "url"
    t.integer "experiment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["experiment_id"], name: "index_links_on_experiment_id"
  end

  create_table "media", force: :cascade do |t|
    t.string "name"
    t.string "media_type"
    t.integer "sort"
    t.integer "experiment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.index ["experiment_id"], name: "index_media_on_experiment_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "role", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.integer "experiment_id"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["experiment_id"], name: "index_videos_on_experiment_id"
  end

end
