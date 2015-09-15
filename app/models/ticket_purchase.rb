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
end
