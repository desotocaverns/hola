class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  def active_for_authentication?
    super && self.activated
  end

  def inactive_message
    "This account has been deactivated."
  end
end
