class Ticket < ActiveRecord::Base

  has_many :revisions,
    class_name: "TicketRevision",
    dependent: :destroy

  scope :for_sale, -> { where(for_sale: true) }

  before_save :increment_version
  after_save :save_revision

  private

  def increment_version
    self.version = version + 1 if changed?
  end

  def current_revision
    TicketRevision.new(
      ticket_id: id,
      version: version,
      ticket_data: {
        description: description,
        price: price
      }
    )
  end

  def save_revision
    current_revision.save!
  end
end
