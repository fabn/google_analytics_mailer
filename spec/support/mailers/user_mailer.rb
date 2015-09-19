require_relative 'abstract_mailer'

class UserMailer < AbstractMailer
  # declare url parameters for this mailer
  google_analytics_mailer utm_source: 'newsletter', utm_medium: 'email' # etc
end
