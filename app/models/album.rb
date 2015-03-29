require 'zip/zip'
require 'zip/zipfilesystem'

class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :songs, :order=>'track, title'
  
  before_save :trim_name
  
  #validators
  validates_presence_of :artist
  
  #Make sure names don't have leading/trailing spaces
  def name=(_name)
    write_attribute(:name, _name.strip)
  end
  
  #Returns a path to a file of all of the tracks, zipped up
  def zip
    raise "No tracks in album #{name}" if songs.empty? 
    bundle_filename = "#{RmedialSetting.default.static_file_path}/zip/#{artist.name} - #{name}.zip"
    raise "Unable to create zip file" if !Medium.path_is_writeable?(bundle_filename)
    
    # check to see if the file exists already, and if it does, delete it.
    File.delete(bundle_filename) if File.file?(bundle_filename) 

    # open or create the zip file
    Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) { |zipfile|
     # collect the album's tracks
     self.songs.collect { |song|
         # add each track to the archive, names using the track's attributes
         zipfile.add(song.ideal_file_name, song.file_name)
       }
    }

    # set read permissions on the file
    File.chmod(0644, bundle_filename)

    return bundle_filename
  end
  
  #returns the most recently added albums
  def self.newest(limit=10)
    Album.find(:all, :include=>[:artist, :songs], :order=>'media.file_mtime DESC', :limit=>limit)
  end
  
  def full_name
    artist.blank? ? name : "#{artist.name} - #{name}"
  end

private

  def trim_name
    name.strip!
  end
end
