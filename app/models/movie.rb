class Movie < Medium
  
  before_validation :set_title
  after_save :create_thumbnail
  after_destroy :destroy_thumbnail
  
  THUMBNAIL_H = 60
  THUMBNAIL_W = 80
  FLVTOOL = RAILS_ROOT + "/vendor/plugins/flvtool2-1.0.6/bin/flvtool2"
  
  STATUS_NOTENCODED = 0
  STATUS_ENCODING = 1
  STATUS_ENCODED = 2
  STATUS_ENCODING_FAILED = 3
  
  def Movie.file_is_movie?(file_path)
    ['.mp4', '.avi'].include?File.extname(file_path)
  end 

  def has_flash_version?
    status == STATUS_ENCODED
  end 

  #If we should show 'encode' as an option
  def can_transcode?  
    [STATUS_NOTENCODED, STATUS_ENCODING_FAILED].include?(status) and subdir_is_writable?
  end
  
  def is_transcoding?
    status == STATUS_ENCODING
  end

  def transcode!
    update_attributes(:status=>STATUS_ENCODING) 
    encoding_command = "#{RmedialSetting.default.path_to_ffmpeg} -i \"#{file_name}\" -s 320x240 -ar 44100 -y \"#{encoded_path}\""
    encoded = system(encoding_command)
    
    if !encoded
      logger.error("Unable to encode #{self}: #{$!}.  Command was: #{encoding_command}")
      update_attributes(:status=>STATUS_ENCODING_FAILED)
    else
      logger.debug("Encoded fine for #{self}.")
      update_attributes(:status=>STATUS_ENCODED)
    end
    
    # ffmpeg does not inject FLV metadata and this will cause skipping back and forth the FLV to be unavailable.
    # Fix this by updating the FLV metadata, including the length.
    if !system("#{FLVTOOL} -U #{encoded_path}")
      logger.warn("Unable to update FLV metadata. Ignoring. #{$!}")
    else
      logger.debug("Updated FLV metadata fine for #{self}.")
    end
  end
  
  def thumbnail_uri
    return full_virtual_path+'/'+id.to_s+'/'+thumbnail_file_name if !full_virtual_path.nil?
  end
  
  def encoded_uri
    return full_virtual_path+'/'+id.to_s+'/'+encoded_file_name if !full_virtual_path.nil?
  end
  
  def thumbnail_path
    File.join(RmedialSetting.default.static_file_path, id.to_s, thumbnail_file_name)
  end
  
  def encoded_path
    File.join(RmedialSetting.default.static_file_path, id.to_s, encoded_file_name)
  end
  
  def thumbnail_file_name
    title+'.jpg'
  end
  
  def encoded_file_name
    title+'.flv'
  end
  
  def has_thumbnail?
    File.exists?(thumbnail_path)
  end
  
  #Given a file path and media path, inserts the movie and returns it
  def Movie.import!(file_path, media_path)
    Movie.find_or_create_by_file_name(:file_name=>file_path, :media_path=>media_path)
  end
  
  def to_s
    "#{self.class} #{self.id}"
  end
  
private

  #sets the name from the file name
  def set_title 
    write_attribute(:title, File.basename(file_name, '.mp4')) if title.blank?
  end
  
  #Checks if the subdirectory we use for storing thumbnails, etc. is writeable.
  #Returns false if it's not, true if it is
  #Creates it if it doesn't exist
  def subdir_is_writable?
    Medium.path_is_writeable?(thumbnail_path)
  end
  
  #generates a thumbnail for the file
  def create_thumbnail
    #create the subfolder if it doesn't exist
    return false if !subdir_is_writable?
    
    if File.exists?(thumbnail_path)
      logger.warn("Not creating thumbnail for movie #{self} because it already exists")
      return
    end
      
    #generate a thumbnail and put it inside that subfolder
    thumbnail_command = "#{RmedialSetting.default.path_to_ffmpeg} -i \"#{file_name}\" -s #{THUMBNAIL_W}x#{THUMBNAIL_H} -an -ss 3 -t 00:00:03 -f mjpeg -y \"#{thumbnail_path}\""
    if !system(thumbnail_command)
      logger.error("Unable to create thumbnail for #{self}: #{$!}.  Ran command: #{thumbnail_command}")
    else
      logger.debug("Created thumbnail fine for #{self}")
    end
  end
  
  def destroy_thumbnail
    File.delete(thumbnail_path) if has_thumbnail?
  end
  
end
