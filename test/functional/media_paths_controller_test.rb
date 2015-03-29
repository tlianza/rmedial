require File.dirname(__FILE__) + '/../test_helper'

class MediaPathsControllerTest < ActionController::TestCase
  
  def test_import_media
    Medium.delete_all
    assert_equal(0, Medium.count)
    post :import_media
    assert_redirected_to rmedial_settings_path
    Kernel.sleep(3)
    assert(0 < Medium.count)
  end
  
  # default tests below
  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_media_path
    assert_difference('MediaPath.count') do
      post :create, :media_path => { :filesystem_path=>'blah' }
    end

    assert_redirected_to rmedial_settings_path
  end

  def test_should_get_edit
    get :edit, :id => media_paths(:one).id
    assert_response :success
  end

  def test_should_update_media_path
    put :update, :id => media_paths(:one).id, :media_path => { }
    assert_redirected_to rmedial_settings_path
  end

  def test_should_destroy_media_path
    assert_difference('MediaPath.count', -1) do
      delete :destroy, :id => media_paths(:one).id
    end

    assert_redirected_to rmedial_settings_path
  end
end
