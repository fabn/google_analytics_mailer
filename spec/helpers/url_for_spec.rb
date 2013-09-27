require 'spec_helper'

describe GoogleAnalyticsMailer::UrlFor do

  before(:each) do
    controller.stub(computed_analytics_params: {utm_source: 'foo'})
  end

  describe '#with_google_analytics_params' do

    it 'should override used parameters while in the block' do
      helper.with_google_analytics_params utm_source: 'bar' do
        helper.url_for('http://www.example.com').should include 'utm_source=bar'
      end
      helper.url_for('http://www.example.com').should include 'utm_source=foo'
    end

  end

  describe '#without_google_analytics_params' do

    it 'should ignore analytic params in the block' do
      helper.without_google_analytics_params do
        helper.url_for('http://www.example.com').should == 'http://www.example.com'
      end
      helper.url_for('http://www.example.com').should include 'utm_source=foo'
    end

  end

end