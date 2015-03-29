require File.dirname(__FILE__) + '/../test_helper'

class MoviesControllerTest < ActionController::TestCase
  
  def test_transcode
    #delete the songs path - don't care about it
    media_paths(:one).destroy
    
    Medium.import!
    valid_movie = nil
    all_movies = Movie.find(:all)
    all_movies.each{|mv| valid_movie = mv if mv.has_thumbnail?}
    assert_not_nil(valid_movie, "No movies had thumbnails")
    
    #now that we have a valid movie, attempt to transcode it
    post :transcode, :id=>valid_movie.id
    Kernel.sleep(1.0)
    valid_movie.reload
    assert_equal(STATUS_ENCODING, valid_movie.status)
  end
end