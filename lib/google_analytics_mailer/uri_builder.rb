require 'addressable/uri'

# Class used to do the actual insertion of parameters
class GoogleAnalyticsMailer::UriBuilder
  def initialize(filter=nil)
    @filter = filter
  end

  # Append google analytics params to the given uri
  # @param [String] uri the original uri
  # @param [Hash] params options for url to build
  # @option params [String] :utm_campaign required is the main GA param
  # @option params [String] :utm_content content of the campaign
  # @option params [String] :utm_source campaign source
  # @option params [String] :utm_medium campaign medium
  # @option params [String] :utm_term keyword for this campaign
  def build(uri, params)
    # remove empty GA params
    params.delete_if { |_, v| v.blank? }
    # if no params return untouched url
    return uri if params.empty?
    # build the final url
    parsed = ::Addressable::URI.parse(uri)
    return uri if @filter && !@filter.call(parsed)

    parsed.query_values = (parsed.query_values || {}).reverse_merge(params) if parsed.absolute?
    parsed.to_s.html_safe
  end

end