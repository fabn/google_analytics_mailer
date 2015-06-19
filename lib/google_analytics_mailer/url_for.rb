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

    # Acts as an around filter from the given block and return its content
    # by merging the given analytics parameters to current ones
    #
    # @param [Hash] params options for url to build
    # @option params [String] :utm_campaign required is the main GA param
    # @option params [String] :utm_content content of the campaign
    # @option params [String] :utm_source campaign source
    # @option params [String] :utm_medium campaign medium
    # @option params [String] :utm_term keyword for this campaign
    #
    # @yield The given block is executed with overridden analytics parameters
    # @yieldreturn [String] content returned from the block with filtered parameters
    #
    # @example in an ERB template
    #   <%= with_google_analytics_params(utm_content: 'foo') do -%>
    #     <%= link_to 'foo', 'http://example.com' -%>
    #   <%- end -%>
    #
    # @example Inline usage now possible because of captured output
    #   <%= with_google_analytics_params(utm_content: 'foo') { link_to ... } -%>
    #
    # @return [String] the output returned by block
    def with_google_analytics_params(params, &block)
      raise ArgumentError, 'Missing block' unless block_given?
      @_override_ga_params = params
      capture(&block)
    ensure
      @_override_ga_params = nil
    end

    # Acts as an around filter from the given block and return its content
    # without inserting any analytics tag
    #
    # @yield The given block is executed with appeding analytics parameters
    # @yieldreturn [String] content returned from the block with no parameters appended
    #
    # @example in an ERB template
    #   <%= without_google_analytics_params(utm_content: 'foo') do -%>
    #     <%= link_to 'foo', 'http://example.com' -%>
    #   <%- end -%>
    #
    # @example Inline usage now possible because of captured output
    #   <%= without_google_analytics_params(utm_content: 'foo') { link_to ... } -%>
    #
    # @return [String] the output of the block executed without analytics params
    def without_google_analytics_params(&block)
      raise ArgumentError, 'Missing block' unless block_given?
      @_override_ga_params = Hash[VALID_ANALYTICS_PARAMS.zip([nil])]
      capture(&block)
    ensure
      @_override_ga_params = nil
    end

    private

    # Return a UriBuilder instance
    # @return [UriBuilder]
    def builder
      @_builder ||= UriBuilder.new controller.class.google_analytics_filter
    end

  end

end