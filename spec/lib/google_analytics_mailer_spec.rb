require 'spec_helper'

describe GoogleAnalyticsMailer do

  it "ActionMailer::Base should extend GoogleAnalyticsMailer" do
    (class << ActionMailer::Base; self end).included_modules.should include(GoogleAnalyticsMailer)
  end

end