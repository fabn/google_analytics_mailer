require 'spec_helper'

# Mock helper used to test module methods
# @see http://stackoverflow.com/questions/5944278/overriding-method-by-another-defined-in-module
class MockHelper
  # No op implementation of url_for
  def url_for(url)
    url
  end

  # Used by implementation
  def controller
    self
  end

  def computed_analytics_params
    {}.with_indifferent_access
  end
end

describe GoogleAnalyticsMailer::UrlFor do

  let(:dummy_class) { Class.new(MockHelper) { include GoogleAnalyticsMailer::UrlFor } }
  let(:subject) { dummy_class.new }

  describe '#url_for' do

    it 'should not include blank GA params' do
      subject.stub(computed_analytics_params: {utm_campaign: nil})
      subject.url_for('http://www.example.com').should_not include 'utm_campaign'
    end

    it 'should uri encode GA parameter values' do
      subject.stub(computed_analytics_params: {utm_campaign: 'Foo Bar'})
      subject.url_for('http://www.example.com').should include 'utm_campaign=Foo%20Bar'
    end

  end

end