class TheBeginning < ActiveRecord::Migration
  def self.up
    #the media files themselves
    create_table :media, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  :media_path_id, :null=>false
      t.text     :file_name,   :null=>false
      t.timestamp :file_mtime, :null=>false
      t.text     :folder_name
      t.integer  :file_size,   :null=>false
      t.string   :type,        :null=>false
      t.string   :title,       :null=>false
      t.integer  :artist_id
      t.integer  :album_id
      t.integer  :year,        :limit=>2
      t.integer  :track,       :limit=>2
      t.string   :genre,       :limit=>40
      t.integer  :status,      :limit=>2,   :default=>0
      t.float    :length
      t.timestamps
    end
    add_index :media, :artist_id
    add_index :media, :album_id
    add_index :media, :media_path_id
    add_index :media, :type
    
    #where media is stored
    create_table :media_paths, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.text     :filesystem_path,   :null=>false
      t.timestamps
    end
    
    #Artists
    create_table :artists, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   :name,    :null=>false
      t.string   :prefix,  :null=>true
      t.timestamps
    end
    add_index :artists, :name, :unique=>true
    
    #Albums
    create_table :albums, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  :artist_id,  :null=>false
      t.string   :name,       :null=>false
      t.integer  :year,       :limit=>2
      t.timestamps
    end
    add_index :albums, :artist_id
    add_index :albums, [:artist_id, :name], :unique=>true
    
    create_table :last_import_errors, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   :file_name,       :null=>false
      t.text     :error
      t.timestamps
    end
    
    create_table :rmedial_settings, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   :static_file_path
      t.text     :path_to_ffmpeg
      t.timestamps
    end
    
  end

  def self.down
    drop_table :media
    drop_table :media_paths
    drop_table :artists
    drop_table :albums
    drop_table :last_import_errors
    drop_table :rmedial_settings
  end
end
