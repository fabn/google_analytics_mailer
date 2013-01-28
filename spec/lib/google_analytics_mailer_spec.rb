require 'spec_helper'

describe GoogleAnalyticsMailer do

  it "ActionMailer::Base should extend GoogleAnalyticsMailer" do
    (class << ActionMailer::Base; self end).included_modules.should include(GoogleAnalyticsMailer)
  end

  describe ".google_analytics_mailer" do

    it "should raise on invalid options for GA params" do
      expect {
        ActionMailer::Base.google_analytics_mailer(foo: 'bar')
      }.to raise_error(ArgumentError, /:foo/)
    end

  end

end