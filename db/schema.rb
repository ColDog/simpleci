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

ActiveRecord::Schema.define(version: 20160709234440) do

  create_table "configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "name"
    t.json     "config"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_configs_on_team_id", using: :btree
    t.index ["user_id"], name: "index_configs_on_user_id", using: :btree
  end

  create_table "jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "repo_id"
    t.integer  "job_id",                                   null: false
    t.string   "key",                                      null: false
    t.string   "branch"
    t.string   "worker"
    t.boolean  "complete",                 default: false
    t.boolean  "cancelled",                default: false
    t.boolean  "failed",                   default: false
    t.text     "failure",    limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["job_id"], name: "index_jobs_on_job_id", using: :btree
    t.index ["key"], name: "index_jobs_on_key", using: :btree
    t.index ["repo_id"], name: "index_jobs_on_repo_id", using: :btree
    t.index ["worker"], name: "index_jobs_on_worker", using: :btree
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_members_on_team_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "repos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "provider",   null: false
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "config_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["config_id"], name: "index_repos_on_config_id", using: :btree
    t.index ["team_id"], name: "index_repos_on_team_id", using: :btree
    t.index ["user_id"], name: "index_repos_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email"
    t.string   "name"
    t.string   "provider"
    t.string   "token"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "configs", "teams"
  add_foreign_key "configs", "users"
  add_foreign_key "jobs", "repos"
  add_foreign_key "members", "teams"
  add_foreign_key "members", "users"
  add_foreign_key "repos", "configs"
  add_foreign_key "repos", "teams"
  add_foreign_key "repos", "users"
end
