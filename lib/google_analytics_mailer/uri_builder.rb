class GoogleAnalyticsMailer::UriBuilder

  # Append google analytics params to the given uri
  def build(uri, params)
    return uri if params.empty?
    # remove empty GA params
    params.delete_if { |_, v| v.blank? }
    # build the final url
    ::Addressable::URI.parse(uri).tap do |parsed|
      parsed.query_values = (parsed.query_values || {}).reverse_merge(params) if parsed.absolute?
    end.to_s.html_safe
  end

end