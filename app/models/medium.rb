class Medium < ActiveRecord::Base
  
  #Relationships
  belongs_to :media_path
  
  #Validations
  validates_presence_of :file_name, :file_size, :title, :media_path, :file_mtime
  validates_numericality_of :file_size
  
  #Callbacks
  before_validation :set_file_size, :set_file_mtime
  before_save       :set_folder_name
  
  #Attributes
  attr_protected :folder_name, :file_size 
  
  
  #This is the main method that imports media from the media_paths, into
  #the database.  
  # NOTE: This currently contains an assumption that all mp3s are music
  #       and all mp4s are video.  This logic should eventually grow to
  #       be smarter and more flexible - probably into it's own function.
  #       For now, it suits my needs.
  
  # TODO: Add error-checking around song info so we can tell people which imports
  #       failed and can be corrected
  def self.import!
    require 'mp3info'
    require 'find'
    
    #traverse the media_paths from the one with the least files to the one with
    #the most.  This should allow for more immediately gratifying imports.
    media_paths = MediaPath.find(:all, :select=>'media_paths.*, count(media.id) as media_count', :joins=>'LEFT JOIN media on media_paths.id=media.media_path_id', :group=>'media_paths.id', :order=>'media_count ASC')
    
  #Keep track of the things we create, so we can destroy the rest
  inserted_media = inserted_albums = inserted_artists = Array.new
  #Delete errors from the import before this one
  LastImportError.delete_all
  
  #iterate through each of the paths, importing songs
  media_paths.each do |mp|

    #First, grab all of the mp3s and create songs
    logger.warn("Beginning file loop for #{mp.normalized_path}")

    Find.find(mp.normalized_path) do |file_path|
      next if !File.file?(file_path)
      
      #see if it's an mp3
      if Song.file_is_song?(file_path)
        begin
          Mp3Info.open(file_path, {:encoding=>'utf-8'}) do |mp3|
            song = Song.find_or_create_by_file_name(:file_name=>file_path, :media_path_id=>mp.id)
            ok = false
            begin 
              #skip processing if we can't get the artist
              artist_name = mp3.tag.artist || mp3.tag2['TP1']
              raise "No artist found in #{file_path}" if artist_name.blank?

              #make sure we have an artist - leave the squeezing, etc to the find method
              artist = Artist.find_or_create_by_name!(artist_name) 
              inserted_artists << artist.id


              #make sure we have an album (TODO: try the album_artist tag or something)
              album_name = mp3.tag.album || mp3.tag2['TAL']
              if !album_name.blank?
                album = Album.find_or_create_by_name_and_artist_id(:name=>album_name.strip, :artist_id=>artist.id, :year=>mp3.tag.year)
                inserted_albums << album.id 
              end

              song_title = mp3.tag.title || mp3.tag2['TT2']
              song_year = mp3.tag.year || mp3.tag2['TYER']
              song_tnum = mp3.tag.tracknum || mp3.tag2['TRCK']
              song_genre = mp3.tag.genre || mp3.tag2['TCON']
              ok = song.update_attributes(
                                        :title=>song_title.strip,
                                        :artist=>artist,
                                        :album=>album,
                                        :year=>song_year,
                                        :track=>song_tnum,
                                        :genre=>song_genre,
                                        :length=>mp3.length)
              rescue 
                #stuff "real" errors in here too, since we want to continue
                p "Error processing song: #{$!}" if 'test'==RAILS_ENV
                song.errors.add_to_base($!)
              end

              if ok
                inserted_media << song.id
              else
                LastImportError.create(:file_name=>song.file_name, :error=>song.errors.full_messages.join("\n"))
              end
            end
        rescue ID3v2Error
          logger.error("Error opening MP3: #{$!} #{$!.backtrace.join("\n")}")
          logger.flush
          LastImportError.create(:file_name=>file_path, :error=>$!)
        end
        
        elsif Movie.file_is_movie?(file_path)
          #insert it if it's a movie
          movie = Movie.import!(file_path, mp)
          inserted_media << movie.id if !movie.id.blank?
        end
      end

      #Use the 'destroy' method for media so that we clean up stuff like movie thumbnails
      inserted_media.empty? ? Medium.destroy_all : Medium.destroy_all(['id NOT IN (?)', inserted_media]) 
      inserted_artists.empty? ? Artist.delete_all : Artist.delete_all(['id NOT IN (?)', inserted_artists])
      inserted_albums.empty? ? Album.delete_all : Album.delete_all(['id NOT IN (?)', inserted_albums])

      logger.warn("Completed an import.  Inserted #{inserted_media.length} media files")   
    end
    
  end
  
private
  
  #sets the file_size before saving
  def set_file_size
    write_attribute(:file_size, File.size(file_name)) if (file_size.blank? and !file_name.blank?)
  end
  
  #Sets the file modification time before saving
  def set_file_mtime
    write_attribute(:file_mtime, File.mtime(file_name)) if (file_mtime.blank? and !file_name.blank?)
  end
  
  #The file portion of the path
  def base_name
    File.basename(file_name)
  end
  
  #The full path of the file minus the file name
  def dir_name
    File.dirname(file_name)
  end
  
  #TODO: this should not be hard coded
  def full_virtual_path
    '/uploads'
  end
  
  #subtracts the media paths out from the full path to get the folder
  def set_folder_name
    media_regexp = Regexp.new("^#{media_path.filesystem_path}[/]?")
    write_attribute(:folder_name, File.dirname(file_name).gsub(media_regexp, ''))
  end
  
  #Given a path to a file, returns whether or not it is writeable, and 
  #will try to create the necessary parent directories
  def self.path_is_writeable?(file_path)
    #create the subfolder if it doesn't exist
    if !File.exists?(File.dirname(file_path))
      begin
        Dir.mkdir(File.dirname(file_path))
        return true
      rescue Errno::EACCES
        logger.error("Unable to create rmedial subdirectory: #{file_path}: #{$!}")
        return false
      end
    else
      return File.writable?(File.dirname(file_path))
    end
  end
end
