class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :invitable
  before_invitation_accepted :activate

  scope :autocratic, -> { where(autocratic: true, activated: true) }
  scope :standard, -> { where(autocratic: false, activated: true) }

  def active_for_authentication?
    super && self.activated
  end

  def inactive_message
    "This account has been deactivated."
  end

  def activate
    self.activated = true
  end
end
