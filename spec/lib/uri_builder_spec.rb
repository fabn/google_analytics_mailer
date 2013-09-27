require 'spec_helper'

describe GoogleAnalyticsMailer::UriBuilder do

  describe '#build' do

    it 'should not include blank GA params' do
      subject.build('http://www.example.com', utm_campaign: nil).should_not include 'utm_campaign'
    end

    it 'should uri encode GA parameter values' do
      subject.build('http://www.example.com', utm_campaign: 'Foo Bar').should include 'utm_campaign=Foo%20Bar'
    end

    it 'should not add GA parameters if uri is not absolute' do
      subject.build('/some/path', utm_campaign: 'abc').should == '/some/path'
    end

    it 'should not touch uri with empty params' do
      subject.build('http://www.example.com', {}).should == 'http://www.example.com'
    end

  end

end