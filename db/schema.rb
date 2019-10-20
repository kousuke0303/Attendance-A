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

ActiveRecord::Schema.define(version: 20191020073349) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "prev_started_at"
    t.datetime "first_started_at"
    t.datetime "finished_at"
    t.datetime "prev_finished_at"
    t.datetime "first_finished_at"
    t.datetime "plans_end_work_time"
    t.string "note"
    t.string "overtime"
    t.string "overtime_content"
    t.integer "overtime_target_user_id"
    t.string "overtime_status"
    t.integer "overtime_tomorrow_check"
    t.integer "overnight"
    t.integer "edit_target_user_id"
    t.string "edit_status"
    t.integer "approve_check"
    t.date "approved_edit"
    t.integer "year"
    t.integer "month"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_points_on_name", unique: true
    t.index ["number"], name: "index_points_on_number", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "affiliation"
    t.boolean "admin", default: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.integer "employee_number"
    t.string "uid"
    t.datetime "basic_work_time", default: "2019-10-19 23:00:00"
    t.datetime "designated_work_start_time", default: "2019-10-20 00:00:00"
    t.datetime "designated_work_end_time", default: "2019-10-20 08:00:00"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
