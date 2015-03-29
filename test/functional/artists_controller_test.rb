require File.dirname(__FILE__) + '/../test_helper'

class ArtistsControllerTest < ActionController::TestCase
  
   def test_filter
    get :index, :filter=>'J'
    assert_response :success
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:artists)
  end

  def test_should_create_artist
    assert_difference('Artist.count') do
      post :create, :artist => { :name=>'asdf' }
    end

    assert_redirected_to artist_path(assigns(:artist))
  end

  def test_should_show_artist
    get :show, :id => artists(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => artists(:one).id
    assert_response :success
  end

  def test_should_update_artist
    put :update, :id => artists(:one).id, :artist => { }
    assert_redirected_to artist_path(assigns(:artist))
  end

  def test_should_destroy_artist
    assert_difference('Artist.count', -1) do
      delete :destroy, :id => artists(:one).id
    end

    assert_redirected_to artists_path
  end
end
