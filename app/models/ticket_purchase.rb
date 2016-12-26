class TicketPurchase < Purchase
  belongs_to :ticket_revision

  def ticket
    ticket_revision.ticket
  end

  def ticket=(object)
    self.ticket_revision = object.revision
  end

  def price
    ticket.price
  end

  def revision_data
    ticket_revision.ticket_data
  end

  def calculate_expiration_date
    ticket_revision = TicketRevision.find(self.ticket_revision_id)
    ticket = Ticket.find(ticket_revision.ticket_id)
    expiration_date = Date.today + ticket.validity_interval
    self.expires_on = expiration_date
  end
end
