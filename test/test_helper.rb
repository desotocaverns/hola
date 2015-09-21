ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  def create_admins
    @admin = Admin.create!(
      email: "bob@randomemployee.com",
      password: "nonautocraticpw",
      activated: true
    )

    @autocratic_admin = Admin.create!(
      email: "isaac@thewilliams.ws",
      password: "isaacspw",
      activated: true,
      autocratic: true
    )
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end
