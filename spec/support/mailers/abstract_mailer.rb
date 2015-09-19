class AbstractMailer < ActionMailer::Base
  default from: 'no-reply@example.com'

  # simulate url helper
  helper do
    def newsletter_url(params = {})
      'http://www.example.com/newsletter'.tap do |u|
        u << "?#{params.to_param}" if params.any?
      end.html_safe
    end
  end

  # Links in this email will have all links with GA params automatically inserted
  def welcome
    mail(to: 'user@example.com')
  end

  def welcome2
    google_analytics_params(utm_source: 'second_newsletter', utm_term: 'welcome2')
    mail(to: 'user@example.com')
  end

  def welcome3
    mail(to: 'user@example.com')
  end
end
