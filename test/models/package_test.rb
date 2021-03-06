require 'test_helper'

class PackageTest < ActiveSupport::TestCase

  def build_single_ticket_package
    @ticket = Ticket.create!(name: "Test", price: 2300)
    @package = Package.new(name: "Testing", price: 1300)
    @package.tickets << @ticket
    @package.save!
  end

  test "invalid without tickets" do
    package = Package.new
    package.save
    assert_equal ["Packages must have tickets assigned."], package.errors[:base]
  end

  test "new record creates revision" do
    build_single_ticket_package
    assert_equal 1, @package.revisions.count
    revision = @package.revisions.first
    assert_equal 1, revision.version
    assert_equal @package.price, revision.price
    assert_equal @package.description, revision.description
    assert_equal @package.tickets.reload, revision.tickets
  end

  test "loading record loads revisions" do
    build_single_ticket_package
    assert_nothing_raised { @package.revision.package }
  end

  test "update record creates revision" do
    build_single_ticket_package
    @package.update!(price: 7300)
    assert_equal 2, @package.revisions.count
    revision = @package.revisions.last
    assert_equal 2, revision.version
    assert_equal 7300, revision.price
  end

  test "add ticket creates revision" do
    build_single_ticket_package
    ticket = Ticket.create!(name: "Test2", price: 2300)
    @package.tickets << ticket
    @package.save!
    assert_equal 2, @package.revisions.count
    revision = @package.revisions.last
    assert_equal @package.tickets, revision.tickets
  end

  test "delete ticket creates revision" do
    build_single_ticket_package
    
    ticket2 = Ticket.create!(name: "Test2", price: 2300)
    ticket3 = Ticket.create!(name: "Test3", price: 2300)
    @package.tickets << ticket2
    @package.tickets << ticket3
    @package.save!

    @package.tickets = [ticket2]
    @package.save!

    assert_equal 3, @package.revisions.count
   
    assert_equal [@ticket], @package.revisions[0].tickets
    assert_equal [@ticket, ticket2, ticket3], @package.revisions[1].tickets
    assert_equal [ticket2], @package.revisions[2].tickets
  end

  test "package.tickets reflects current ticket data" do
    build_single_ticket_package
    @ticket.update_attribute(:price, 100)

    @package.reload
    assert_equal 1, @package.revisions.count
    assert_equal 100, @package.tickets.first.price
  end

  test "package.revision.tickets reflects ticket data at last package revision" do
    build_single_ticket_package
    @ticket.update_attribute(:price, 100)

    @package.reload
    assert_equal 1, @package.revisions.count
    assert_equal 2300, @package.revision.tickets.first.price
  end

  test "package_tickets handles quantities" do
    ticket = Ticket.create!(name: "Test", price: 2300)
    package = Package.new(name: "Testing", price: 2300)
    package.package_tickets << PackageTicket.new(ticket: ticket, quantity: 3)

    package.save!
    
    assert_equal [ticket], package.tickets
    assert_equal package.package_tickets.first.quantity, 3
  end

  test "a ticket can be added only once" do
    build_single_ticket_package
    assert_raises(ActiveRecord::RecordNotUnique) do
      @package.tickets << @ticket
    end
  end
end
