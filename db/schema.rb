# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "albums", :force => true do |t|
    t.integer  "artist_id",                               :null => false
    t.string   "name",                    :default => "", :null => false
    t.integer  "year",       :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "albums", ["artist_id", "name"], :name => "index_albums_on_artist_id_and_name", :unique => true
  add_index "albums", ["artist_id"], :name => "index_albums_on_artist_id"

  create_table "artists", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "prefix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artists", ["name"], :name => "index_artists_on_name", :unique => true

  create_table "last_import_errors", :force => true do |t|
    t.string   "file_name",  :default => "", :null => false
    t.text     "error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media", :force => true do |t|
    t.integer  "media_path_id",                               :null => false
    t.text     "file_name",                   :default => "", :null => false
    t.datetime "file_mtime",                                  :null => false
    t.text     "folder_name"
    t.integer  "file_size",                                   :null => false
    t.string   "type",                        :default => "", :null => false
    t.string   "title",                       :default => "", :null => false
    t.integer  "artist_id"
    t.integer  "album_id"
    t.integer  "year",          :limit => 2
    t.integer  "track",         :limit => 2
    t.string   "genre",         :limit => 40
    t.integer  "status",        :limit => 2,  :default => 0
    t.float    "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["artist_id"], :name => "index_media_on_artist_id"
  add_index "media", ["album_id"], :name => "index_media_on_album_id"
  add_index "media", ["media_path_id"], :name => "index_media_on_media_path_id"
  add_index "media", ["type"], :name => "index_media_on_type"

  create_table "media_paths", :force => true do |t|
    t.text     "filesystem_path", :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rmedial_settings", :force => true do |t|
    t.string   "static_file_path"
    t.text     "path_to_ffmpeg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
