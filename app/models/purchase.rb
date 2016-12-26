require 'securerandom'

class Purchase < ActiveRecord::Base
  belongs_to :sale, touch: true

  before_create :generate_unique_token
  before_save :calculate_expiration_date # Defined by children

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
end
