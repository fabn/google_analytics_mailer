class GoogleAnalyticsMailer::UriBuilder

  # Append google analytics params to the given uri
  def build(uri, params)
    # remove empty GA params
    params.delete_if { |_, v| v.blank? }
    # if no params return untouched url
    return uri if params.empty?
    # build the final url
    ::Addressable::URI.parse(uri).tap do |parsed|
      parsed.query_values = (parsed.query_values || {}).reverse_merge(params) if parsed.absolute?
    end.to_s.html_safe
  end

end