ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  def create_admins
    @admin = Admin.create!(
      email: "bob@randomemployee.com",
      password: "nonautocraticpw"
    )

    @autocratic_admin = Admin.create!(
      email: "isaac@thewilliams.ws",
      password: "isaacspw",
      autocratic: true
    )
  end

  def setup_admin(admin_type=:autocratic)
    create_admins
    admin_type == :autocratic ? sign_in(@autocratic_admin) : sign_in(@admin)
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end
