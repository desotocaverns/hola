require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "getting index results in redirect if not autocratic admin" do
    create_admins
    sign_in(@admin)

    get :index
    assert_redirected_to new_sale_path, {'message' => 'You are not authorized'}
  end

  test "creating without name results in failure" do
    create_admins
    sign_in(@autocratic_admin)

    post :create, {"ticket"=>{"name"=>"", "description"=>"", "price"=>"0.0", "for_sale_on(1i)"=>"2015", "for_sale_on(2i)"=>"9", "for_sale_on(3i)"=>"21"}}
    assert_template "new"
    assert_equal Ticket.all.empty?, true
  end
end
