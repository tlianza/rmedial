class Song < Medium
  
  #Relationships
  belongs_to :artist
  belongs_to :album
  
  #Validations
  validates_presence_of :artist
  
  def detail
    detail_string = ""
    detail_string << " year #{year}" if !year.blank?
    detail_string << " track #{track}" if !track.blank?
    detail_string << " from #{album.name}" if !album.blank?
    detail_string
  end
  
  def full_name
    artist.name+' - '+title
  end
  
  #if we're going to spit this out as a file, make the filename consistent
  def ideal_file_name
    ideal_name = ""
    ideal_name << sprintf("%.2i", track)+' - ' if !track.blank?
    ideal_name << full_name << File.extname(file_name)
    ideal_name
  end
  
  def Song.file_is_song?(file_path)
    '.mp3' == File.extname(file_path)
  end
  
  def to_s
    "#{self.class}: #{self.id}"
  end
end