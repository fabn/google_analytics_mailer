require "google_analytics_mailer/version"
require "google_analytics_mailer/url_for"
require "action_mailer"
require "active_support/concern"

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
    cattr_accessor(:google_analytics_class_params) { params }

    # include the module which provides the actual functionality
    include GoogleAnalytics

  end

  # This module provides methods to deal with parameter merging and similar stuff
  module GoogleAnalytics

    # uses concern to include it
    extend ActiveSupport::Concern

    # this code is evaluated in class context
    included do
      helper GoogleAnalyticsMailer::UrlFor
    end

    # This method return the actual parameters to use when building links
    # @return [Hash] computed parameters
    def computed_analytics_params
      @_computed_ga_params ||= self.class.google_analytics_class_params.merge(@_ga_instance_params || {})
    end

    private
    # Instance level parameters, used only for the given message
    def google_analytics_params params
      @_ga_instance_params = params
    end

  end

end

# Add the class method to ActionMailer::Base
ActionMailer::Base.send :extend, GoogleAnalyticsMailer