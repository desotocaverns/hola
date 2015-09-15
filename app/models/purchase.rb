require 'securerandom'

class Purchase < ActiveRecord::Base
  belongs_to :sale, touch: true

  before_create :generate_unique_token
  before_save :calculate_expiration_date
  before_destroy :validate_one_or_more_purchases

  # Answers the name of the Purchase item at the time the Purchase was created.
  def name
    revision_data["name"]
  end

  private

  def validate_one_or_more_purchases
    if sale.purchases.count <= 1
      return false
    end
  end

  def calculate_expiration_date
    expiration_date = Time.now + 1.years
    self.expires_on = expiration_date
  end
  
  def generate_unique_token
    self.token = SecureRandom.urlsafe_base64(10) + self.id.to_s
  end
end
