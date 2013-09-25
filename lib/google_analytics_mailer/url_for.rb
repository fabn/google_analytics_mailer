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
      # remove empty GA params
      params_to_add.delete_if { |_, v| v.blank? }
      # if there are no parameters return super value
      if params_to_add.empty?
        super(original_url)
      else
        # else parse the url and append given parameters
        ::Addressable::URI.parse(super(original_url)).tap do |url|
          url.query_values = (url.query_values || {}).reverse_merge(params_to_add) if url.absolute?
        end.to_s.html_safe
      end
    end

    # Allow to override Google Analytics params for a given block in views
    # @return [String]
    def with_google_analytics_params(params)
      raise ArgumentError, "Missing block" unless block_given?
      @_override_ga_params = params
      yield
      @_override_ga_params = nil
      nil # do not return any value
    end

  end

end