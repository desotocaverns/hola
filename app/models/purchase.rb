require 'securerandom'

class Purchase < ActiveRecord::Base
  belongs_to :sales
  has_many :redemption_codes, dependent: :destroy

  before_create :generate_unique_token
  before_save :generate_redemption_codes, :calculate_expiration_date

  validates_numericality_of :quantity

  private

  def calculate_expiration_date
    expiration_date = Time.now + 1.years
    self.expires_on = expiration_date
  end

  def generate_redemption_codes
    quantity.times do |i|
      expiration_date = Time.now + 1.years
      expiration_date_string = expiration_date.strftime("%d%m%y")
      code = expiration_date_string + SecureRandom.urlsafe_base64(10)
      self.redemption_codes << RedemptionCode.create(code: code) 
    end
  end
  
  def generate_unique_token
    self.token = SecureRandom.urlsafe_base64(10) + self.id.to_s
  end
end
