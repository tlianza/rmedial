require File.dirname(__FILE__) + '/../test_helper'

class MediumTest < ActiveSupport::TestCase
  
  #make sure we can tolerate slashes or not
  def test_import_tolerance
    MediaPath.delete_all
    Medium.delete_all
    mp1 = MediaPath.create(:filesystem_path=>"#{RAILS_ROOT}/test/fixtures/songs")
   
    Medium.import!
    first_media_count = Medium.count
    
    #empty the database
    MediaPath.delete_all
    Medium.delete_all
   
    #this one has a trailing slash
    mp2 = MediaPath.create(:filesystem_path=>"#{RAILS_ROOT}/test/fixtures/songs/")
    Medium.import!
    
    assert_equal(first_media_count, Medium.count, "Ended up with a different number of media depending on the slash")
  end
end
