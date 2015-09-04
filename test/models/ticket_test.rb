require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  test "revisions" do
    assert_equal 0, TicketRevision.count
    ticket = Ticket.create!(name: "Test", price: 2300, description: "Testing")
    assert_equal 1, TicketRevision.count
    
    revision = ticket.revisions.first
    assert_equal 1, revision.version
    assert_equal ticket.price, revision.price
    assert_equal ticket.description, revision.description

    ticket.update!(price: 7300)
    revision = ticket.revisions.last
    assert_equal 2, revision.version
    assert_equal 7300, revision.price
  end
end
