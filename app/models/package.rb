class Package < ActiveRecord::Base
  
  has_many :revisions,
    class_name: "PackageRevision",
    dependent: :destroy
  
  # Associates Tickets to this Package.
  has_many :package_tickets,
    dependent: :destroy

  # Answers Tickets associated to this Package. Note that this reflects the current
  # Ticket information! Use the #revision to obtain Ticket information at current
  # revision of this Package.
  has_many :tickets,
    through: :package_tickets

  before_save :increment_version
  after_save :save_revision

  validate :must_have_tickets

  # Answers a PackageRevision which contains the current Package data. This will be the last
  # recorded revision if the Package is unchanged, otherwise it will be an unsaved PackageRevision
  # reflecting the current state of the Package.
  def revision
    changed? ? current_revision : revisions.last
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
        description: description,
        price: price,
        tickets: tickets
      }
    )
  end

  def save_revision
    current_revision.save!
  end

  def must_have_tickets
    errors.add(:base, "Packages must have tickets assigned.") unless tickets.size > 0
  end
end