require "test_helper"

class UserManagementControllerTest < ActionDispatch::IntegrationTest
  test "should get assign_roles" do
    get user_management_assign_roles_url
    assert_response :success
  end
end
