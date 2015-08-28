class TicketRevision < ActiveRecord::Base
  store_accessor :ticket_data, :description, :price
end
