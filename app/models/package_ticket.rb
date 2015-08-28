# Represents the association of a Package to a Ticket. The data of
# the Ticket at the time the association is created must be obtained through
# the TicketRevision having the ticket_version recorded here.
class PackageTicket < ActiveRecord::Base
  belongs_to :package
  belongs_to :ticket

  before_save :capture_versions

  private

  def capture_versions
  	self.ticket_version = ticket.version
  end
end
