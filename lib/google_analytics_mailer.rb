require "google_analytics_mailer/version"
require "action_mailer"

# This module declares the main class method which is then callable from every
# ActionMailer class
module GoogleAnalyticsMailer

  def google_analytics_mailer

  end

end

# Add the class method to ActionMailer::Base
ActionMailer::Base.send :extend, GoogleAnalyticsMailer