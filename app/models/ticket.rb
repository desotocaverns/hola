class Ticket < ActiveRecord::Base
  has_many :revisions,
    class_name: "TicketRevision"

  before_create :assign_default_priority
  before_save :increment_version
  after_save :save_revision

  validates :name, presence: true
  validates_numericality_of :price, greater_than: 0

  scope :for_sale, -> { where("for_sale_on <= NOW()") }

  # Answers a TicketRevision which contains the current Ticket data. This will be the last
  # recorded revision if the Ticket is unchanged, otherwise it will be an unsaved TicketRevision
  # reflecting the current state of the Ticket.
  def revision
    changed? ? current_revision : revisions.last
  end

  private

  def increment_version
    self.version = version + 1 if changed?
  end

  def current_revision
    TicketRevision.new(
      ticket_id: id,
      version: version,
      ticket_data: {
        name: name,
        description: description,
        price: price,
        priority: priority
      }
    )
  end

  def save_revision
    current_revision.save!
  end

  def assign_default_priority
    self.priority = (self.class.order(:priority).last.try(:priority) || 0) + 1
  end
end
