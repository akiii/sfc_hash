require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  test "should get submit" do
    get :submit
    assert_response :success
  end

end
