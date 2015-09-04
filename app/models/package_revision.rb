class PackageRevision < ActiveRecord::Base
  store_accessor :package_data, :description, :price

  def package
    Package.new(package_data.except("ticket_revision_ids")).tap do |p|
      p.tickets = tickets
      p.readonly!
    end
  end

  def tickets
    TicketRevision.find(package_data["ticket_revision_ids"]).map do |revision|
      Ticket.new(revision.ticket_data.merge(id: revision.ticket_id)).tap {|t| t.readonly! }
    end
  end
end
