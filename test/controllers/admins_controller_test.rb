require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  test "getting index results in redirect if not autocratic admin" do
    create_admins
    sign_in(@admin)

    get :index
    assert_redirected_to sales_path, {'message' => 'You are not authorized'}
  end
end
