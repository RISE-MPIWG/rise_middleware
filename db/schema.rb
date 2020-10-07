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

ActiveRecord::Schema.define(version: 2019_03_14_164318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "fuzzystrmatch"
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "collections", force: :cascade do |t|
    t.integer "created_by_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "original_uuid"
    t.string "resources_url"
    t.bigint "organisation_id"
    t.string "name"
    t.string "slug"
    t.string "api_url"
    t.jsonb "metadata", default: "{}", null: false
    t.boolean "archived", default: false
    t.integer "access_type", default: 0
    t.integer "api_mapping_module", default: 0
    t.datetime "remote_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_type"], name: "index_collections_on_access_type"
    t.index ["api_mapping_module"], name: "index_collections_on_api_mapping_module"
    t.index ["archived"], name: "index_collections_on_archived"
    t.index ["created_by_id"], name: "index_collections_on_created_by_id"
    t.index ["metadata"], name: "index_collections_on_metadata", using: :gin
    t.index ["organisation_id"], name: "index_collections_on_organisation_id"
    t.index ["slug"], name: "index_collections_on_slug"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "content_units", force: :cascade do |t|
    t.bigint "section_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.bigint "resource_id"
    t.jsonb "metadata"
    t.string "name"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metadata"], name: "index_content_units_on_metadata", using: :gin
    t.index ["resource_id"], name: "index_content_units_on_resource_id"
    t.index ["section_id"], name: "index_content_units_on_section_id"
  end

  create_table "corpora", force: :cascade do |t|
    t.integer "created_by_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name"
    t.text "description"
    t.boolean "archived", default: false
    t.integer "privacy_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archived"], name: "index_corpora_on_archived"
    t.index ["created_by_id"], name: "index_corpora_on_created_by_id"
    t.index ["privacy_type"], name: "index_corpora_on_privacy_type"
  end

  create_table "corpus_resources", force: :cascade do |t|
    t.bigint "corpus_id"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["corpus_id"], name: "index_corpus_resources_on_corpus_id"
    t.index ["resource_id"], name: "index_corpus_resources_on_resource_id"
  end

  create_table "organisation_collections", force: :cascade do |t|
    t.bigint "organisation_id"
    t.bigint "collection_id"
    t.string "api_key", default: ""
    t.integer "access_right", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_right"], name: "index_organisation_collections_on_access_right"
    t.index ["collection_id"], name: "index_orc_collection"
    t.index ["organisation_id"], name: "index_orc_organisation"
  end

  create_table "organisation_research_tools", force: :cascade do |t|
    t.bigint "organisation_id"
    t.bigint "research_tool_id"
    t.integer "access_right"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_organisation_research_tools_on_organisation_id"
    t.index ["research_tool_id"], name: "index_organisation_research_tools_on_research_tool_id"
  end

  create_table "organisation_resources", force: :cascade do |t|
    t.bigint "organisation_id"
    t.bigint "resource_id"
    t.integer "access_right"
    t.jsonb "acl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_organisation_resources_on_organisation_id"
    t.index ["resource_id"], name: "index_organisation_resources_on_resource_id"
  end

  create_table "organisation_users", force: :cascade do |t|
    t.bigint "organisation_id"
    t.bigint "user_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_organisation_users_on_organisation_id"
    t.index ["user_id"], name: "index_organisation_users_on_user_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.integer "created_by_id"
    t.string "name"
    t.string "slug"
    t.string "api_url"
    t.integer "api_mapping_module", default: 0
    t.string "saml_issuer_uri"
    t.string "api_key"
    t.integer "organisation_type"
    t.boolean "archived", default: false
    t.integer "default_collection_access_type", default: 0
    t.jsonb "default_collection_metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_mapping_module"], name: "index_organisations_on_api_mapping_module"
    t.index ["archived"], name: "index_organisations_on_archived"
    t.index ["created_by_id"], name: "index_organisations_on_created_by_id"
    t.index ["default_collection_access_type"], name: "index_organisations_on_default_collection_access_type"
    t.index ["default_collection_metadata"], name: "index_organisations_on_default_collection_metadata", using: :gin
    t.index ["organisation_type"], name: "index_organisations_on_organisation_type"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "research_tool_collections", force: :cascade do |t|
    t.bigint "research_tool_id"
    t.bigint "collection_id"
    t.integer "access_right"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_orrt_collection"
    t.index ["research_tool_id"], name: "index_orrt_research_tool"
  end

  create_table "research_tools", force: :cascade do |t|
    t.integer "created_by_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name"
    t.text "description"
    t.string "url"
    t.string "slug"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archived"], name: "index_research_tools_on_archived"
    t.index ["created_by_id"], name: "index_research_tools_on_created_by_id"
    t.index ["slug"], name: "index_research_tools_on_slug"
  end

  create_table "resources", force: :cascade do |t|
    t.integer "created_by_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "original_uuid", default: ""
    t.datetime "remote_updated_at"
    t.bigint "collection_id"
    t.bigint "organisation_id"
    t.string "name"
    t.string "uri"
    t.jsonb "contents"
    t.jsonb "metadata"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archived"], name: "index_resources_on_archived"
    t.index ["collection_id"], name: "index_resources_on_collection_id"
    t.index ["created_by_id"], name: "index_resources_on_created_by_id"
    t.index ["metadata"], name: "index_resources_on_metadata", using: :gin
    t.index ["organisation_id"], name: "index_resources_on_organisation_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "resource_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name"
    t.string "uri"
    t.string "original_parent_uuid"
    t.string "original_uuid"
    t.jsonb "metadata"
    t.string "ancestry"
    t.boolean "is_leaf", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_sections_on_ancestry"
    t.index ["is_leaf"], name: "index_sections_on_is_leaf"
    t.index ["metadata"], name: "index_sections_on_metadata", using: :gin
    t.index ["resource_id"], name: "index_sections_on_resource_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tool_exports", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name"
    t.text "notes"
    t.bigint "user_id"
    t.jsonb "resource_metadata", default: "{}", null: false
    t.bigint "research_tool_id"
    t.string "file_data"
    t.integer "privacy_type", default: 0
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archived"], name: "index_tool_exports_on_archived"
    t.index ["privacy_type"], name: "index_tool_exports_on_privacy_type"
    t.index ["research_tool_id"], name: "index_tool_exports_on_research_tool_id"
    t.index ["resource_metadata"], name: "index_tool_exports_on_resource_metadata", using: :gin
    t.index ["user_id"], name: "index_tool_exports_on_user_id"
  end

  create_table "user_logs", force: :cascade do |t|
    t.string "loggable_type"
    t.bigint "loggable_id"
    t.string "subject_type"
    t.bigint "subject_id"
    t.bigint "organisation_id"
    t.string "controller"
    t.string "action"
    t.jsonb "raw_request"
    t.string "request_origin"
    t.string "request_method"
    t.string "request_body"
    t.jsonb "request_params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loggable_type", "loggable_id"], name: "index_user_logs_on_loggable_type_and_loggable_id"
    t.index ["organisation_id"], name: "index_user_logs_on_organisation_id"
    t.index ["subject_type", "subject_id"], name: "index_user_logs_on_subject_type_and_subject_id"
  end

  create_table "user_resources", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "resource_id"
    t.integer "access_right"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_user_resources_on_resource_id"
    t.index ["user_id"], name: "index_user_resources_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "xasia_token", default: "", null: false
    t.integer "preferred_language"
    t.integer "role", default: 2
    t.boolean "archived", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.bigint "organisation_id"
    t.string "affiliation"
    t.string "name"
    t.string "position"
    t.string "auth_token"
    t.datetime "token_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.index ["auth_token"], name: "index_users_on_auth_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
