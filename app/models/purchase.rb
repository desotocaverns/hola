require 'securerandom'

class Purchase < ActiveRecord::Base
  belongs_to :sale, touch: true

  before_create :generate_unique_token
  before_save :calculate_expiration_date # Defined by children

  validate :quantity_non_zero

  # Answers the name of the Purchase item at the time the Purchase was created.
  def name
    revision_data["name"]
  end

  def expired?
    self.expires_on <= Date.today
  end

  private

  def generate_unique_token
    self.token = SecureRandom.urlsafe_base64(10) + self.id.to_s
  end

  def quantity_non_zero
    if !self.quantity || self.quantity <= 0
      errors.add(:quantity, "can't be zero")
    end
  end
end
