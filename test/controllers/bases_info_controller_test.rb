require 'test_helper'

class BasesInfoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bases_info_index_url
    assert_response :success
  end

end
