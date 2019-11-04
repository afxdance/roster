require 'test_helper'

class ConfirmEmailControllerTest < ActionDispatch::IntegrationTest
  test "should get click" do
    get confirm_email_click_url
    assert_response :success
  end

end
