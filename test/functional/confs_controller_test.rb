require 'test_helper'

class ConfsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:confs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conf" do
    assert_difference('Conf.count') do
      post :create, :conf => { }
    end

    assert_redirected_to conf_path(assigns(:conf))
  end

  test "should show conf" do
    get :show, :id => confs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => confs(:one).to_param
    assert_response :success
  end

  test "should update conf" do
    put :update, :id => confs(:one).to_param, :conf => { }
    assert_redirected_to conf_path(assigns(:conf))
  end

  test "should destroy conf" do
    assert_difference('Conf.count', -1) do
      delete :destroy, :id => confs(:one).to_param
    end

    assert_redirected_to confs_path
  end
end
