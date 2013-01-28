require 'spec_helper'

describe GoogleAnalyticsMailer do

  it "ActionMailer::Base should extend GoogleAnalyticsMailer" do
    (class << ActionMailer::Base; self end).included_modules.should include(GoogleAnalyticsMailer)
  end

  describe ".google_analytics_mailer" do

    class TestMailer1 < ActionMailer::Base
    end

    it "should raise on invalid options for GA params" do
      expect {
        ActionMailer::Base.google_analytics_mailer(foo: 'bar')
      }.to raise_error(ArgumentError, /:foo/)
    end

    it "should assign given parameters to a class variable" do
      params = {utm_source: 'newsletter', utm_medium: 'email'}
      TestMailer1.google_analytics_mailer(params)
      TestMailer1.google_analytics_params.should == params
    end

    it "should create an accessor for instances" do
      TestMailer1.send(:new).should respond_to :google_analytics_params
      TestMailer1.send(:new).should respond_to :google_analytics_params=
    end

  end

end