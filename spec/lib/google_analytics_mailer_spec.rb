RSpec.describe GoogleAnalyticsMailer do

  it 'ActionMailer::Base should extend GoogleAnalyticsMailer' do
    expect((
           class << ActionMailer::Base;
             self
           end).included_modules).to include(GoogleAnalyticsMailer)
  end

  describe '.google_analytics_mailer' do

    class TestMailer1 < ActionMailer::Base
    end

    it 'should raise on invalid options for GA params' do
      expect {
        ActionMailer::Base.google_analytics_mailer(foo: 'bar')
      }.to raise_error(ArgumentError, /:foo/)
    end

    it 'should assign given parameters to a class variable' do
      params = {utm_source: 'newsletter', utm_medium: 'email'}
      TestMailer1.google_analytics_mailer(params)
      expect(TestMailer1.google_analytics_class_params).to eq(params)
    end

  end

  describe 'Mailer objects' do

    # Used in groups, retrieve mailer using example description
    subject do |example|
      mailer_action = example.example_group.description.sub /^\./, ''
      described_class.public_send(mailer_action).tap do |email|
        # Message must be delivered to trigger interceptors, ensure Rails < 4.2 compatibility
        email.respond_to?(:deliver_now) ? email.deliver_now : email.deliver
      end
    end

    # This method is a monkeypatch coming from EmailSpec to return email body as string
    let(:email_body) { subject.default_part_body }

    describe FilteredMailer do

      # see view in spec/support/views/user_mailer/welcome.html.erb
      describe '.welcome' do

        it 'should have analytics link with params taken from class definition' do
          expect(email_body).to have_link 'Read online', href: 'http://www.example.com/newsletter?utm_medium=email&utm_source=newsletter'
        end

        it 'should have analytics link with overridden params' do
          expect(email_body).to have_link 'Read online', href: 'http://www.example.com/newsletter?utm_medium=email&utm_source=my_newsletter'
        end

        it 'should have non-http link with no tracking' do
          # Capybara matcher uses exact match for href, not substrings
          expect(email_body).to have_link 'External link', href: 'http://www.external.com/'
        end
      end
    end

    describe UserMailer do

      # see view in spec/support/views/user_mailer/welcome.html.erb
      describe '.welcome' do

        it 'should remove custom headers' do
          all_headers = subject.header.fields.map(&:name)
          expect(all_headers).not_to include GoogleAnalyticsMailer::Interceptor::PARAMS_HEADER
          expect(all_headers).not_to include GoogleAnalyticsMailer::Interceptor::CLASS_HEADER
        end

        it 'should have analytics link with params taken from class definition' do
          expect(email_body).to have_link 'Read online', href: 'http://www.example.com/newsletter?utm_medium=email&utm_source=newsletter'
        end

        it 'should have analytics link with overridden params' do
          expect(email_body).to have_link 'Read online', href: 'http://www.example.com/newsletter?utm_medium=email&utm_source=my_newsletter'
        end

      end

      # see view in spec/support/views/user_mailer/welcome2.html.erb
      describe '.welcome2' do

        it 'should have analytics link with params taken from instance' do
          expect(email_body).to have_link 'Read online', href: 'http://www.example.com/newsletter?utm_medium=email&utm_source=second_newsletter&utm_term=welcome2'
        end

        it 'should have analytics link with overridden params' do
          expect(email_body).to have_link 'Read online', href: 'http://www.example.com/newsletter?utm_medium=email&utm_source=my_newsletter&utm_term=welcome2'
        end

      end

    end
  end

end