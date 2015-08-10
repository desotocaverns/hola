# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.gmail.com',
  :domain         => 'mail.google.com',
  :port           => 587,
  :user_name      => 'isaac@thewilliams.ws',
  :password       => '>36dr?3Z&%/J$Dj',
  :authentication => :plain,
  :enable_starttls_auto => true
}
