require 'test_helper'

class PackagesControllerTest < ActionController::TestCase
  test "creating without name results in failure" do
    setup_admin()

    post :create, {"package"=>{"name"=>"", "description"=>"", "price"=>"", "package_tickets_attributes"=>[{"quantity"=>"", "ticket_id"=>"1"}, {"quantity"=>"", "ticket_id"=>"2"}, {"quantity"=>"", "ticket_id"=>"3"}], "for_sale_on(1i)"=>"2015", "for_sale_on(2i)"=>"9", "for_sale_on(3i)"=>"21"}}
    assert_template "new"
    assert_equal Package.all.empty?, true
  end
end
