require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  def create_admins
    @admin = Admin.create!(
      email: "bob@randomemployee.com",
      password: "nonautocraticpw",
      activated: true
    )
  end

  test "getting index results in redirect if not autocratic admin" do
    create_admins
    sign_in(@admin)

    get :index
    assert_redirected_to new_sale_path, {'message' => 'You are not authorized'}
  end
end
