# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081101083013) do

  create_table "captcha_on_iknow_demos", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iknow3g_exams", :force => true do |t|
    t.integer  "user_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iknow3g_items", :force => true do |t|
    t.string   "key"
    t.text     "data"
    t.integer  "num_of_question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "have_not_sentence"
  end

  create_table "iknow3g_progresses", :force => true do |t|
    t.integer  "iknow3g_item_id"
    t.integer  "iknow3g_exam_id"
    t.integer  "point"
    t.integer  "position"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iknow3g_users", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.string   "iknow_user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

end
