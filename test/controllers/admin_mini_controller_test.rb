require "test_helper"

class AdminMiniControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get admin_mini_login_url
    assert_response :success
  end

  test "should get posts" do
    get admin_mini_posts_url
    assert_response :success
  end
end
