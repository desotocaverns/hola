require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def build_package
    @ticket = Ticket.create!(name: "Test", price: 2300, description: "Testing")
    @package = Package.new(price: 2300, description: "Testing")
    @package.tickets << @ticket
    @package.save!
  end
end
