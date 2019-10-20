require 'test_helper'

class BasisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get basis_index_url
    assert_response :success
  end

end
