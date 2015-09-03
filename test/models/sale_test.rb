require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def build_package
    @ticket = Ticket.create!(name: "Test", price: 2300, description: "Testing")
    @package = Package.new(name: "Testing", price: 2300)
    @package.tickets << @ticket
    @package.save!
  end

  def build_ticket
    @ticket = Ticket.create!(name: "Test", price: 2300, description: "Testing")
  end

  test "sale ticket purchase" do
  	build_ticket

  	sale = Sale.new
    sale.purchases << TicketPurchase.new(ticket: @ticket)
    sale.save!
  	
  	purchase = sale.purchases.first
    assert_equal 1, purchase.quantity
    assert_equal @ticket.revision, purchase.ticket_revision
  end
end
