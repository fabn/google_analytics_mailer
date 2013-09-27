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

  describe '#with_google_analytics_params' do

    it 'should override used parameters while in the block' do
      subject.stub(computed_analytics_params: {utm_source: 'foo'})
      subject.with_google_analytics_params utm_source: 'bar' do
        subject.url_for('http://www.example.com').should include 'utm_source=bar'
      end
      subject.url_for('http://www.example.com').should include 'utm_source=foo'
    end

  end

  describe '#without_google_analytics_params' do

    it 'should ignore analytic params in the block' do
      subject.stub(computed_analytics_params: {utm_source: 'foo'})
      subject.without_google_analytics_params do
        subject.url_for('http://www.example.com').should == 'http://www.example.com'
      end
      subject.url_for('http://www.example.com').should include 'utm_source=foo'
    end

  end

end