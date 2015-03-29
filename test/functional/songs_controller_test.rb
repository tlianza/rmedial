require File.dirname(__FILE__) + '/../test_helper'

class SongsControllerTest < ActionController::TestCase
   
  

  def test_should_show_song
    get :show, :id => media(:one).id
    assert_response :success
  end

 
  def test_should_destroy_song
    assert_difference('Song.count', -1) do
      delete :destroy, :id => media(:one).id
    end

    assert_redirected_to songs_path
  end
end
