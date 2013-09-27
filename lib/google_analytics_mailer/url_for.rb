require "addressable/uri"

module GoogleAnalyticsMailer # :nodoc:

  # This module is added as helper to ActionMailer objects and override
  # the url_for default implementation to insert GA params into generated links
  module UrlFor

    # Override default url_for method to insert ga params
    #
    # @return [String] the modified url
    def url_for(original_url)
      # Fetch final parameters calling private method
      params_to_add = controller.computed_analytics_params.with_indifferent_access
      # temporary override coming from with_google_analytics_params method
      params_to_add.merge!(@_override_ga_params) if @_override_ga_params.try(:any?)
      # Avoid parse if params not given
      params_to_add.empty? ? super(original_url) : builder.build(super(original_url), params_to_add)
    end

    # Allow to override Google Analytics params for a given block in views
    # @return [String]
    def with_google_analytics_params(params)
      raise ArgumentError, "Missing block" unless block_given?
      @_override_ga_params = params
      yield
      nil # do not return any value
    ensure
      @_override_ga_params = nil
    end

    private

    # Return a UriBuilder instance
    # @return [UriBuilder]
    def builder
      @_builder ||= UriBuilder.new
    end

  end

end