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

ActiveRecord::Schema.define(:version => 20130412143447) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "collaborators", :force => true do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "conditions", :force => true do |t|
    t.decimal "value",  :precision => 12, :scale => 4
    t.string  "unit"
    t.string  "name"
    t.integer "hit_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "hits", :force => true do |t|
    t.integer  "receiver_deployment_id"
    t.integer  "tag_deployment_id"
    t.string   "tag_code"
    t.datetime "time"
    t.decimal  "depth",                                                                              :precision => 8, :scale => 4
    t.datetime "created_at"
    t.string   "receiver_model"
    t.string   "receiver_serial"
    t.spatial  "location",               :limit => {:srid=>4326, :type=>"point", :geographic=>true}
  end

  create_table "otn_arrays", :force => true do |t|
    t.string "code"
    t.text   "description"
    t.string "waterbody"
    t.string "region"
  end

  add_index "otn_arrays", ["code"], :name => "index_otn_arrays_on_code"

  create_table "receiver_deployments", :force => true do |t|
    t.integer  "receiver_id"
    t.datetime "start"
    t.integer  "study_id"
    t.integer  "otn_array_id"
    t.string   "name"
    t.integer  "station"
    t.boolean  "seasonal"
    t.decimal  "riser_length",                                                                                              :precision => 8, :scale => 2
    t.decimal  "bottom_depth",                                                                                              :precision => 8, :scale => 2
    t.decimal  "instrument_depth",                                                                                          :precision => 8, :scale => 2
    t.boolean  "funded"
    t.boolean  "proposed"
    t.datetime "proposed_ending"
    t.integer  "consecutive"
    t.string   "deployed_by"
    t.datetime "recovery_date"
    t.spatial  "recovery_location", :limit => {:srid=>4326, :type=>"point", :has_z=>true, :has_m=>true, :geographic=>true}
    t.boolean  "data_downloaded"
    t.boolean  "ar_confirm"
    t.spatial  "location",          :limit => {:srid=>4326, :type=>"point", :geographic=>true}
  end

  add_index "receiver_deployments", ["receiver_id"], :name => "index_receiver_deployments_on_receiver_id"
  add_index "receiver_deployments", ["study_id"], :name => "index_receiver_deployments_on_study_id"

  create_table "receivers", :force => true do |t|
    t.string  "model"
    t.integer "frequency"
    t.string  "serial"
    t.integer "rcv_modem_address"
    t.boolean "vps"
  end

  create_table "reports", :force => true do |t|
    t.string   "input_tag",                                                                                                                         :null => false
    t.text     "description"
    t.string   "method"
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "city"
    t.string   "state"
    t.datetime "reported"
    t.datetime "found"
    t.decimal  "length",                                                                           :precision => 6, :scale => 2
    t.string   "fishtype"
    t.spatial  "location",             :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer  "tag_deployment_id"
    t.boolean  "contacted"
    t.boolean  "resolved"
    t.string   "input_external_codes"
    t.string   "address"
    t.string   "zipcode",              :limit => 8
    t.boolean  "newsletter",                                                                                                     :default => false
    t.string   "didwith"
    t.text     "comments"
    t.decimal  "depth",                                                                            :precision => 6, :scale => 2
  end

  add_index "reports", ["input_tag"], :name => "index_reports_on_tag"
  add_index "reports", ["location"], :name => "index_reports_on_location", :spatial => true
  add_index "reports", ["tag_deployment_id"], :name => "index_reports_on_tag_deployment_id"
  add_index "reports", ["tag_deployment_id"], :name => "index_reports_on_tag_id"

  create_table "studies", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start"
    t.datetime "ending"
    t.string   "url"
    t.string   "species"
    t.integer  "user_id"
    t.string   "code",                    :limit => 20,                        :null => false
    t.text     "title"
    t.text     "benefits"
    t.text     "organizations"
    t.text     "funding"
    t.text     "objectives"
    t.text     "investigators"
    t.string   "img_first_file_name"
    t.string   "img_first_content_type"
    t.integer  "img_first_file_size"
    t.datetime "img_first_updated_at"
    t.string   "img_second_file_name"
    t.string   "img_second_content_type"
    t.integer  "img_second_file_size"
    t.datetime "img_second_updated_at"
    t.string   "img_third_file_name"
    t.string   "img_third_content_type"
    t.integer  "img_third_file_size"
    t.datetime "img_third_updated_at"
    t.string   "img_fourth_file_name"
    t.string   "img_fourth_content_type"
    t.integer  "img_fourth_file_size"
    t.datetime "img_fourth_updated_at"
    t.string   "img_fifth_file_name"
    t.string   "img_fifth_content_type"
    t.integer  "img_fifth_file_size"
    t.datetime "img_fifth_updated_at"
    t.string   "permissions",                           :default => "private"
    t.boolean  "approved",                              :default => false
  end

  create_table "submissions", :force => true do |t|
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "study_id"
    t.string   "datatype"
    t.string   "datafile_file_name"
    t.string   "datafile_content_type"
    t.integer  "datafile_file_size"
    t.datetime "datafile_updated_at"
    t.boolean  "cleardata",             :default => false
  end

  create_table "tag_deployments", :force => true do |t|
    t.integer  "tag_id"
    t.string   "tagger"
    t.string   "common_name"
    t.string   "scientific_name"
    t.string   "capture_location"
    t.spatial  "capture_geo",                               :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "capture_date"
    t.decimal  "capture_depth",                                                                                         :precision => 6, :scale => 2
    t.string   "wild_or_hatchery"
    t.string   "stock"
    t.decimal  "length",                                                                                                :precision => 6, :scale => 2
    t.decimal  "weight",                                                                                                :precision => 6, :scale => 2
    t.string   "age"
    t.string   "sex"
    t.boolean  "dna_sample_taken"
    t.string   "treatment_type"
    t.decimal  "temperature_change",                                                                                    :precision => 4, :scale => 2
    t.decimal  "holding_temperature",                                                                                   :precision => 4, :scale => 2
    t.string   "surgery_location"
    t.spatial  "surgery_geo",                               :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "surgery_date"
    t.string   "sedative"
    t.string   "sedative_concentration"
    t.string   "anaesthetic"
    t.string   "buffer"
    t.string   "anaesthetic_concentration"
    t.string   "buffer_concentration_in_anaesthetic"
    t.string   "anesthetic_concentration_in_recirculation"
    t.string   "buffer_concentration_in_recirculation"
    t.decimal  "do",                                                                                                    :precision => 6, :scale => 1
    t.text     "description"
    t.string   "release_group"
    t.string   "release_location"
    t.spatial  "release_geo",                               :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "release_date"
    t.string   "external_codes"
    t.string   "length_type"
    t.string   "implant_type"
    t.string   "reward"
    t.integer  "study_id"
    t.string   "sensor_codes"
    t.string   "lifespan"
    t.datetime "expiration_date"
  end

  add_index "tag_deployments", ["capture_geo"], :name => "index_tag_deployments_on_capture_geo", :spatial => true
  add_index "tag_deployments", ["release_geo"], :name => "index_tag_deployments_on_release_geo", :spatial => true
  add_index "tag_deployments", ["surgery_geo"], :name => "index_tag_deployments_on_surgery_geo", :spatial => true
  add_index "tag_deployments", ["tag_id"], :name => "index_tag_deployments_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string  "serial"
    t.string  "code"
    t.string  "code_space"
    t.string  "model"
    t.string  "manufacturer"
    t.string  "type"
    t.text    "description"
    t.integer "active_deployment_id"
  end

  add_index "tags", ["model"], :name => "index_tags_on_model"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",                  :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "role"
    t.boolean  "approved",                            :default => false, :null => false
    t.string   "name"
    t.string   "organization"
    t.string   "requested_role"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode",                :limit => 8
    t.string   "phone"
    t.boolean  "newsletter",                          :default => false
    t.string   "authentication_token"
  end

  add_index "users", ["approved"], :name => "index_users_on_approved"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
