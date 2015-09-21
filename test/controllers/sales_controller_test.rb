require 'test_helper'

class SalesControllerTest < ActionController::TestCase
  def build_ticket
    @ticket = Ticket.create!(name: "Test", price: 2300, description: "Testing")
  end

  test "getting new is successful" do
    get :new
    assert_response :success
  end

  test "getting index results in redirect if not admin" do
    get :index
    assert_redirected_to new_admin_session_path
  end

  test "trying to return to summary after sale completion results in redirect" do
    build_ticket
    sale = Sale.new(name: "Arnold", email: "arnold@schwarzenegger.ws", charge_id: "ch_16ZSOgJiVRz9VXanvB8T1RG7")
    sale.purchases << TicketPurchase.new(ticket: @ticket)
    sale.save

    get :summarize, {"redemption_code" => "#{sale.redemption_code}"}
    assert_redirected_to new_sale_path
  end
end
