class Package < ActiveRecord::Base
  has_many :revisions,
    class_name: "PackageRevision"
  
  # Associates Tickets to this Package.
  has_many :package_tickets,
    dependent: :destroy
  accepts_nested_attributes_for :package_tickets

  # Answers Tickets associated to this Package. Note that this reflects the associated
  # Tickets but does not include quantity information. Obtain quantities using the
  # package_tickets.
  #
  # If you add a Ticket through this association, it will default to a quantity of 1.
  #
  # Use the #revision to obtain Ticket information at current revision of this Package.
  has_many :tickets,
    through: :package_tickets

  before_create :assign_default_priority, :assign_default_for_sale_on
  before_save :increment_version
  after_save :save_revision

  validate :must_have_tickets
  validates :name, presence: true
  validates_numericality_of :price, greater_than: 0

  scope :for_sale, -> { where("for_sale_on <= NOW()") }

  # Answers a PackageRevision which contains the current Package data. This will be the last
  # recorded revision if the Package is unchanged, otherwise it will be an unsaved PackageRevision
  # reflecting the current state of the Package.
  def revision
    changed? ? current_revision : revisions.last
  end

  def full_price
    package_tickets.inject(0) { |acc, pt| acc + Ticket.find_by(id: pt.ticket_id).price * pt.quantity }
  end

  def savings
    (full_price - price)
  end

  def savings_percentage
    "#{((1 - (price.to_f / full_price.to_f)) * 100).round}%"
  end

  private

  def increment_version
    self.version = version + 1 if changed?
  end

  def current_revision
    PackageRevision.new(
      package_id: id,
      version: version,
      package_data: {
        name: name,
        description: description,
        price: price,
        ticket_revision_ids: ticket_revision_ids,
        priority: priority
      }
    )
  end

  def ticket_revision_ids
    ticket_revision_ids = []

    tickets.each do |t|
      ticket_revision_ids << t.revision.id
    end

    ticket_revision_ids
  end

  def save_revision
    current_revision.save!
  end

  def must_have_tickets
    errors.add(:base, "Packages must have tickets assigned.") unless package_tickets.size > 0
  end

  def assign_default_priority
    self.priority = (self.class.order(:priority).last.try(:priority) || 0) + 1
  end

  def assign_default_for_sale_on
    if self.for_sale_on == nil
      self.for_sale_on = Time.now
    end
  end
end
