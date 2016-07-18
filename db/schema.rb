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

ActiveRecord::Schema.define(version: 20160717234504) do

  create_table "job_definitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.json     "repo"
    t.json     "builds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_job_definitions_on_user_id", using: :btree
  end

  create_table "jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "job_definition_id",                               null: false
    t.integer  "user_id"
    t.integer  "job_id",                                          null: false
    t.string   "key",                                             null: false
    t.json     "build",                                           null: false
    t.string   "worker"
    t.boolean  "complete",                        default: false
    t.boolean  "cancelled",                       default: false
    t.boolean  "failed",                          default: false
    t.text     "failure",           limit: 65535
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["job_definition_id"], name: "index_jobs_on_job_definition_id", using: :btree
    t.index ["job_id"], name: "index_jobs_on_job_id", using: :btree
    t.index ["key"], name: "index_jobs_on_key", using: :btree
    t.index ["user_id"], name: "index_jobs_on_user_id", using: :btree
    t.index ["worker"], name: "index_jobs_on_worker", using: :btree
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "target_id"
    t.integer  "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_members_on_source_id", using: :btree
    t.index ["target_id"], name: "index_members_on_target_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email"
    t.string   "name"
    t.string   "username",   null: false
    t.string   "provider"
    t.string   "token"
    t.string   "uid",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "job_definitions", "users"
  add_foreign_key "jobs", "job_definitions"
  add_foreign_key "jobs", "users"
  add_foreign_key "members", "users", column: "source_id"
  add_foreign_key "members", "users", column: "target_id"
end
