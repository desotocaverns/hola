require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def build_package
    @ticket = Ticket.create!(name: "Test", price: 2300, description: "Testing")
    @package = Package.new(price: 2300, description: "Testing")
    @package.tickets << @ticket
    @package.save!
  end

  test "purchases created with sales" do
  	build_package
  	sale = Sale.new(name: "Jon Claude", email: "theterminator@gmail.com", tax: 92, total_price: 2392)
  	assert Purchase.all.empty?
  	
  	sale.save!
  	assert_equal Purchase.all.empty?, false
  end
end
