require_relative 'abstract_mailer'

class FilteredMailer < AbstractMailer
  # declare url parameters for this mailer
  google_analytics_mailer utm_source: 'newsletter', utm_medium: 'email', filter: ->(uri) { uri.host == 'www.example.com' }
end
