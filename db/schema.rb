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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150517041231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "api_keys", force: true do |t|
    t.string   "token",      null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename",    limit: 255
    t.string   "filetype",    limit: 255
    t.integer  "filesize"
    t.integer  "sheet_id"
    t.string   "url",         limit: 255
    t.datetime "deleted_at"
    t.integer  "price_cents"
  end

  add_index "assets", ["deleted_at"], name: "index_assets_on_deleted_at", using: :btree
  add_index "assets", ["sheet_id"], name: "index_assets_on_sheet_id", using: :btree

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flags", force: true do |t|
    t.integer  "user_id"
    t.integer  "sheet_id",               null: false
    t.string   "email",      limit: 255
    t.text     "message",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["sheet_id"], name: "index_flags_on_sheet_id", using: :btree
  add_index "flags", ["user_id"], name: "index_flags_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "notes", force: true do |t|
    t.integer  "user_id",                             null: false
    t.string   "title",       limit: 255,             null: false
    t.string   "slug",        limit: 255
    t.text     "body",                                null: false
    t.integer  "body_type",               default: 0
    t.integer  "visibility",              default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "description",                         null: false
  end

  add_index "notes", ["slug"], name: "index_notes_on_slug", unique: true, using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "sheet_id",                                       null: false
    t.integer  "user_id",                                        null: false
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                             default: 0
    t.string   "payer_id"
    t.string   "tracking_id",            limit: 255,             null: false
    t.integer  "amount_cents",                                   null: false
    t.string   "pdf_file_name",          limit: 255
    t.string   "pdf_content_type",       limit: 255
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.integer  "royalty_cents"
    t.integer  "price_cents",                                    null: false
    t.string   "billing_full_name"
    t.string   "billing_address_line_1"
    t.string   "billing_address_line_2"
    t.string   "billing_city"
    t.string   "billing_state_province"
    t.string   "billing_country"
    t.string   "billing_zipcode"
    t.inet     "ip"
    t.integer  "category",                           default: 0, null: false
    t.string   "email",                  limit: 255
  end

  add_index "orders", ["sheet_id"], name: "index_orders_on_sheet_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "sheets", force: true do |t|
    t.boolean  "is_flagged",                          default: false, null: false
    t.string   "title",                   limit: 255,                 null: false
    t.text     "description",                                         null: false
    t.integer  "pages",                               default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "difficulty"
    t.integer  "instruments"
    t.string   "pdf_file_name",           limit: 255
    t.string   "pdf_content_type",        limit: 255
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string   "slug",                    limit: 255
    t.integer  "user_id",                                             null: false
    t.integer  "cached_votes_total",                  default: 0
    t.integer  "cached_votes_score",                  default: 0
    t.integer  "cached_votes_up",                     default: 0
    t.integer  "cached_votes_down",                   default: 0
    t.integer  "cached_weighted_score",               default: 0
    t.integer  "cached_weighted_total",               default: 0
    t.float    "cached_weighted_average",             default: 0.0
    t.integer  "price_cents",                         default: 0,     null: false
    t.datetime "deleted_at"
    t.integer  "license"
    t.integer  "total_sold",                          default: 0
    t.integer  "visibility",                          default: 0
    t.text     "description_html"
    t.boolean  "enable_pdf_stamping",                 default: false
    t.boolean  "pay_what_you_want",                   default: true
    t.string   "cached_joined_tags",                  default: [],                 array: true
    t.string   "cached_genres",                       default: [],                 array: true
    t.string   "cached_composers",                    default: [],                 array: true
    t.string   "cached_sources",                      default: [],                 array: true
    t.integer  "assets_count",                        default: 0,     null: false
    t.boolean  "limit_purchases",                     default: false, null: false
    t.integer  "limit_purchase_quantity",             default: 0,     null: false
    t.integer  "orders_count",                        default: 0,     null: false
    t.string   "cached_publishers"
  end

  add_index "sheets", ["cached_votes_down"], name: "index_sheets_on_cached_votes_down", using: :btree
  add_index "sheets", ["cached_votes_score"], name: "index_sheets_on_cached_votes_score", using: :btree
  add_index "sheets", ["cached_votes_total"], name: "index_sheets_on_cached_votes_total", using: :btree
  add_index "sheets", ["cached_votes_up"], name: "index_sheets_on_cached_votes_up", using: :btree
  add_index "sheets", ["cached_weighted_average"], name: "index_sheets_on_cached_weighted_average", using: :btree
  add_index "sheets", ["cached_weighted_score"], name: "index_sheets_on_cached_weighted_score", using: :btree
  add_index "sheets", ["cached_weighted_total"], name: "index_sheets_on_cached_weighted_total", using: :btree
  add_index "sheets", ["deleted_at"], name: "index_sheets_on_deleted_at", using: :btree
  add_index "sheets", ["slug"], name: "index_sheets_on_slug", unique: true, using: :btree
  add_index "sheets", ["user_id"], name: "index_sheets_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id",                                 null: false
    t.integer  "membership_type",                         null: false
    t.integer  "status",                      default: 0
    t.string   "tracking_id",     limit: 255,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_id",      limit: 255
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "image",                  limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "username",               limit: 255
    t.boolean  "finished_registration?",             default: false
    t.string   "tagline",                limit: 255
    t.string   "website",                limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "membership_type",                    default: 0,     null: false
    t.string   "paypal_email",           limit: 255
    t.boolean  "has_published",                      default: false
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "cached_display_name",    limit: 255
    t.string   "timezone",               limit: 255
    t.string   "billing_full_name"
    t.string   "billing_address_line_1"
    t.string   "billing_address_line_2"
    t.string   "billing_city"
    t.string   "billing_state_province"
    t.string   "billing_country"
    t.string   "billing_zipcode"
    t.string   "facebook_username"
    t.string   "twitter_username"
    t.string   "googleplus_username"
    t.string   "soundcloud_username"
    t.string   "youtube_username"
    t.integer  "orders_count",                       default: 0,     null: false
    t.integer  "sheets_count",                       default: 0,     null: false
    t.text     "about"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type", limit: 255
    t.integer  "voter_id"
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag"
    t.string   "vote_scope",   limit: 255
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
