require "test_helper"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get teams_create_url
    assert_response :success
  end
end
