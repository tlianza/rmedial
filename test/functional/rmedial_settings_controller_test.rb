require File.dirname(__FILE__) + '/../test_helper'

class RmedialSettingsControllerTest < ActionController::TestCase
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:rmedial_settings)
  end

  def test_should_get_edit
    get :edit, :id => RmedialSetting.default.id
    assert_response :success
  end

  def test_should_update_rmedial_setting
    put :update, :id => RmedialSetting.default.id, :rmedial_setting => { }
    assert_redirected_to rmedial_settings_path
  end

end
