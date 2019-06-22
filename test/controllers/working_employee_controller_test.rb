require 'test_helper'

class WorkingEmployeeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get working_employee_index_url
    assert_response :success
  end

end
