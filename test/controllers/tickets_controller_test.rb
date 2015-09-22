require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "getting index results in redirect if not autocratic admin" do
    setup_admin(:basic)

    get :index
    assert_redirected_to new_sale_path, {'message' => 'You are not authorized'}
  end

  test "creating without name results in failure" do
    setup_admin()

    post :create, {"ticket"=>{"name"=>"", "description"=>"", "price"=>"0.0", "for_sale_on(1i)"=>"2015", "for_sale_on(2i)"=>"9", "for_sale_on(3i)"=>"21"}}
    assert_template "new"
    assert_equal Ticket.all.empty?, true
  end

  test "creating with for_sale => 'true' makes for_sale_on today" do
    setup_admin()

    post :create, {"ticket"=>{"name"=>"YoYo", "description"=>"YoYo's are fun", "price"=>"20.00", "for_sale"=>"true", "for_sale_on(1i)"=>"2015", "for_sale_on(2i)"=>"9", "for_sale_on(3i)"=>"21"}}
    assert_redirected_to ticket_path(Ticket.last.id), {'message' => 'Ticket was successfully created.'}
    assert_equal Ticket.last.for_sale_on, Date.today
  end

  test "creating with for_sale => 'false' makes for_sale_on nil" do
    setup_admin()

    post :create, {"ticket"=>{"name"=>"YoYo", "description"=>"YoYo's are fun", "price"=>"20.00", "for_sale"=>"false", "for_sale_on(1i)"=>"2015", "for_sale_on(2i)"=>"9", "for_sale_on(3i)"=>"21"}}
    assert_redirected_to ticket_path(Ticket.last.id), {'message' => 'Ticket was successfully created.'}
    assert_equal Ticket.last.for_sale_on, nil
  end
end
