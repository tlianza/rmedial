require File.dirname(__FILE__) + '/../test_helper'

class MovieTest < ActiveSupport::TestCase
  
  def setup
    #don't care about music
    media_paths(:one).destroy
  end
  
  def test_basic_construction
    #make sure blank movies can't be created
    assert_raise ActiveRecord::RecordInvalid do
      movie = Movie.create!
    end
    
    #this should fail without a file_name
    assert_raise ActiveRecord::RecordInvalid do
      movie = Movie.create!(:file_size=>1234)
    end
     
  end
  
  def test_create_folder_name    
    movie = Movie.create!(:file_name=>media_paths(:two).filesystem_path+'/Dexter/Dexter-Episode1.mp4', :media_path=>media_paths(:two))
    assert_equal('Dexter', movie.folder_name) 
    assert(File.exists?(File.dirname(movie.thumbnail_path)))
    Dir.delete(File.dirname(movie.thumbnail_path))
  end
  
  def test_import
    Medium.import!
    
    assert(Movie.count > 0, 'No movies found :(')
    
    anavi = nil
    Movie.find(:all).each{|movie|
      anavi = movie if File.extname(movie.file_name) == '.avi'
      #make sure they didn't end up with paths for titles
      assert_not_equal(movie.file_name, movie.title)
    }
    
    assert_not_nil(anavi, "No avis imported: #{Movie.find(:all).map{|movie| movie.file_name}*','}")
    
    #ensure you can re-import with no harmful effects
    Medium.import!
  end
  
  def test_encode_movie
    Medium.import!
    valid_movie = nil
    Movie.find(:all).each{|movie|
      valid_movie = movie if movie.has_thumbnail?
    }
    assert_not_nil(valid_movie)
    assert_equal(Movie::STATUS_NOTENCODED, valid_movie.status)
    valid_movie.transcode!
    valid_movie.reload
    assert(valid_movie.has_flash_version?, "Movie should have had a flash version.")
  end
end
