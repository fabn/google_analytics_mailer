require "google_analytics_mailer/version"
require "action_mailer"

# This module declares the main class method which is then callable from every
# ActionMailer class
module GoogleAnalyticsMailer

  # These are the currently GA allowed get params for link tagging
  VALID_ANALYTICS_PARAMS = [:utm_source, :utm_medium, :utm_campaign,
                            :utm_term, :utm_content]

  # Enable google analytics link tagging for the mailer which call this method
  def google_analytics_mailer params = {}
    if (params.keys - VALID_ANALYTICS_PARAMS).any?
      raise ArgumentError, "Invalid parameters keys #{params.keys - VALID_ANALYTICS_PARAMS}"
    end

    # add accessor for class level parameters
    cattr_accessor(:google_analytics_params) { params }
    # add accessor for instance level parameters
    attr_accessor(:google_analytics_params)
  end

end

# Add the class method to ActionMailer::Base
ActionMailer::Base.send :extend, GoogleAnalyticsMailer