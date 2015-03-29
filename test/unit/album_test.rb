require File.dirname(__FILE__) + '/../test_helper'

class AlbumTest < ActiveSupport::TestCase
  
  def test_newest
    assert_not_nil(Album.newest)
  end
  
  def test_zip
    album = albums(:one)
    zip_file = album.zip
    assert(File.file?(zip_file), "Zip file was not a file: #{zip_file}")
    #cleanup after ourselves
    File.delete(zip_file)
  end
end
