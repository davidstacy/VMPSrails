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

ActiveRecord::Schema.define(:version => 20090522194330) do

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "confs", :force => true do |t|
    t.integer  "switch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename"
  end

  create_table "hosts", :force => true do |t|
    t.string    "mac",      :limit => 24,                  :null => false
    t.text      "hostname",                                :null => false
    t.string    "vlan",     :limit => 128, :default => "", :null => false
    t.string    "ip",       :limit => 24
    t.timestamp "updated",                                 :null => false
  end

  create_table "switches", :primary_key => "switchuid", :force => true do |t|
    t.string "name",  :limit => 128, :default => "", :null => false
    t.string "ip",    :limit => 128, :default => "", :null => false
    t.string "model", :limit => 128,                 :null => false
    t.binary "vmps",  :limit => 1
  end

  create_table "vlans", :force => true do |t|
    t.text "name", :null => false
  end

end
