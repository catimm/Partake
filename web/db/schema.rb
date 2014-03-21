# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140307210824) do

  create_table "authentications", :force => true do |t|
    t.string   "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "friend_name"
    t.string   "friend_email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "event_package_options", :force => true do |t|
    t.integer  "event_id"
    t.integer  "package_instance_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "event_package_options", ["event_id"], :name => "index_event_package_options_on_event_id"
  add_index "event_package_options", ["package_instance_id"], :name => "index_event_package_options_on_package_instance_id"

  create_table "event_time_options", :force => true do |t|
    t.integer  "event_id"
    t.datetime "time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_time_options", ["event_id"], :name => "index_event_time_options_on_event_id"

  create_table "event_time_user_choices", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "response"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "event_time_option_id"
  end

  add_index "event_time_user_choices", ["event_time_option_id"], :name => "index_event_time_user_choices_on_event_time_option_id"
  add_index "event_time_user_choices", ["user_id"], :name => "index_event_time_choices_on_user_id"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "fb_friends", :force => true do |t|
    t.integer  "user_id"
    t.string   "friend_name"
    t.integer  "friend_fbid", :limit => 8
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "finalized_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "package_instance_id"
    t.datetime "timestamp"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "confirmed"
  end

  add_index "finalized_events", ["event_id"], :name => "index_finalized_events_on_event_id"
  add_index "finalized_events", ["package_instance_id"], :name => "index_finalized_events_on_package_instance_id"

  create_table "invitees", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "accepted"
  end

  add_index "invitees", ["event_id"], :name => "index_invitees_on_event_id"
  add_index "invitees", ["user_id"], :name => "index_invitees_on_user_id"

  create_table "package_instances", :force => true do |t|
    t.integer  "package_id"
    t.time     "available_start_time"
    t.time     "available_end_time"
    t.integer  "price"
    t.integer  "min_people"
    t.integer  "max_people"
    t.integer  "max_available"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "cancel_notice"
    t.string   "available_days"
    t.string   "advance_notice"
  end

  add_index "package_instances", ["package_id"], :name => "index_package_instances_on_package_id"

  create_table "package_responses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "package_instance_id"
    t.boolean  "response"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "packages", :force => true do |t|
    t.integer  "venue_id"
    t.string   "package_type"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "enabled"
    t.string   "title"
    t.string   "image_url"
  end

  add_index "packages", ["venue_id"], :name => "index_packages_on_venue_id"

  create_table "ratings", :force => true do |t|
    t.integer  "package_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.string   "category"
    t.text     "comments"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ratings", ["package_id"], :name => "index_ratings_on_package_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "requests", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "responses", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.boolean  "response"
    t.integer  "event_package_option_id"
  end

  add_index "responses", ["event_package_option_id"], :name => "index_event_package_user_choices_on_event_package_option_id"
  add_index "responses", ["user_id"], :name => "index_event_package_choices_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",           :null => false
    t.string   "encrypted_password",                  :default => "",           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0,            :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_customer_id"
    t.string   "authentication_token"
    t.integer  "mobile_number",          :limit => 8
    t.string   "role",                                :default => "registered", :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["mobile_number"], :name => "index_users_on_mobile_number"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "cuisine"
    t.integer  "phone"
    t.string   "website"
    t.string   "facebook"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "hours1"
    t.string   "hours2"
    t.string   "hours3"
    t.string   "hours4"
    t.string   "contact_first_name"
    t.string   "contact_last_name"
    t.string   "contact_role"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "contact_email"
    t.integer  "contact_phone"
    t.string   "neighborhood"
  end

end
