require File.dirname(__FILE__) + '/../test_helper'

class SongTest < ActiveSupport::TestCase
  
  UNICODE_TO_ISO = Iconv.new("ISO-8859-1", "UTF-8")
  ISO_TO_UNICODE = Iconv.new("UTF-8", "ISO-8859-1")
  
  def test_basic_construction
    base_path = media_paths(:one).filesystem_path
    
    #make sure blank songs can't be created
    assert_raise ActiveRecord::RecordInvalid do
      song = Song.create!
    end
     
    #this should fail without a title or artist
    assert_raise ActiveRecord::RecordInvalid do
      song = Song.create!(:file_name=>base_path+'/albumless_song.mp3')
    end
    
    #this should be the minimally required set
    song = Song.create!(:file_name=>base_path+'/albumless_song.mp3', :title=>'Test Song', :artist=>artists(:two), :media_path=>media_paths(:one))
    assert_equal('Song', song.type)
    
    #should even be able to use a blank year
    song2 = Song.create!(:file_name=>base_path+'/artistless_song.mp3', :title=>'Another Test', :artist=>artists(:two), :media_path=>media_paths(:one), :year=>'')
  end
  
  def test_import
    #empty the database of all media
    Medium.destroy_all
    Artist.destroy_all    
    #destroy the movies media_path (don't care)
    media_paths(:two).destroy
    
    assert_equal(0, Medium.count)
    assert_equal(0, Song.count)
    assert_equal(0, Movie.count)
    assert_equal(0, Artist.count) 
    
    #try an import
    Medium.import!
    after_count = Medium.count 
    
    #some errors are ok, depending on our test files
    first_error_count = LastImportError.count
    assert(after_count > 0, "Didn't import any media")
    assert(Song.count > 0, 'No songs found :(')
    assert(Artist.count > 0) 
    assert(media_paths(:one).media.size > 0) 
   
    assert_equal(1, Artist.count(:conditions=>["name=?", 'Journey']), "Failed search for artist 'Journey': #{Artist.find(:all).map{|artist| artist.name}*','}")
    assert_equal(1, Album.count(:conditions=>["name='Greatest Hits'"]), "Failed search for Greatest Hits Albums")
   
    assert(Song.count(:conditions=>'length is not null').size > 0)
    
    #make sure we can find some songs with weird characters
    assert_not_nil(Artist.find_by_name('Björk'), "Failed search for artist Björk: #{Artist.find(:all).map{|artist| artist.name}*','}")
    
    #make sure the songs (in a subfolder) have a folder
    assert_not_nil(Song.find_by_folder_name('Journey'), "No songs in the Journey folder?") 
     
    #ensure you can re-import with no harmful effects
    Medium.import!

    assert_equal(after_count, Medium.count, "The second import changed the number of files?")
    assert_equal(first_error_count, LastImportError.count)
    
    #delete last path, and ensure our counts go to zero
    mp = media_paths(:one)
    mp.destroy
    Medium.import!
    
    #we should have lost all of the songs
    assert_equal(0, Medium.count)
    assert_equal(0, Song.count)
    assert_equal(0, LastImportError.count)
  
  end
  
  def test_ideal_file_name
    song = media(:one)
    assert_equal("01 - Journey - Wheel In The Sky.mp3", song.ideal_file_name)
  end
   
end
