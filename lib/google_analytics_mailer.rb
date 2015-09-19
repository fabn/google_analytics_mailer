require 'google_analytics_mailer/version'
require 'google_analytics_mailer/uri_builder'
require 'google_analytics_mailer/interceptor'
require 'google_analytics_mailer/injector'
require 'action_mailer'
require 'json'

# This module declares the main class method which is then callable from every
# ActionMailer class and in ActionController::Base if available.
module GoogleAnalyticsMailer

  # These are the currently GA allowed get params for link tagging
  VALID_ANALYTICS_PARAMS = [:utm_source, :utm_medium, :utm_campaign, :utm_term, :utm_content, :filter]

  # Enable google analytics link tagging for the mailer (or controller) which call this method
  #
  # @param [Hash] params options for url to build
  # @option params [String] :utm_campaign required is the main GA param
  # @option params [String] :utm_content content of the campaign
  # @option params [String] :utm_source campaign source
  # @option params [String] :utm_medium campaign medium
  # @option params [String] :utm_term keyword for this campaign
  def google_analytics_mailer(params = {})
    if (params.keys - VALID_ANALYTICS_PARAMS).any?
      raise ArgumentError, "Invalid parameters keys #{params.keys - VALID_ANALYTICS_PARAMS}"
    end

    filter = params.delete(:filter)

    # add accessor for class level parameters
    cattr_accessor(:google_analytics_class_params) { params }
    cattr_accessor(:google_analytics_filter) { filter }

    # include the module which provides some instance methods
    include GoogleAnalytics
    # Take care of serialize params in a custom header processed by interceptor
    default GoogleAnalyticsMailer::Interceptor::HEADER_NAME => proc { JSON.dump(computed_analytics_params) }
  end

  # This module provides methods to deal with parameter merging and similar stuff
  module GoogleAnalytics

    # This method return the actual parameters to use when building links
    # @return [Hash] computed parameters
    def computed_analytics_params
      @_computed_ga_params ||= self.class.google_analytics_class_params.merge(@_ga_instance_params || {})
    end

    private
    # Instance level parameters, used only for the given message
    def google_analytics_params(params)
      @_ga_instance_params = params
    end

  end

end

# Add the class method to ActionMailer::Base
ActionMailer::Base.send :extend, GoogleAnalyticsMailer
# Add the interceptor, it does the hard work. Interceptors are global and not per class.
ActionMailer::Base.register_interceptor GoogleAnalyticsMailer::Interceptor
