require File.dirname(__FILE__) + '/../test_helper'

class MediaControllerTest < ActionController::TestCase
  def test_should_play
    get :play, :id=>media(:one).id
    assert_response :success
  end
end
 