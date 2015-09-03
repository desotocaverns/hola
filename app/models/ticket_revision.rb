class TicketRevision < ActiveRecord::Base
  store_accessor :ticket_data, :description, :price

  def ticket
	Ticket.new(ticket_data).tap {|t| t.readonly! }
  end
end
