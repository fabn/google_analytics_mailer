require 'base64'

# This class is used as mail interceptor to detect GA configuration and to trigger
# parameters injection.
class GoogleAnalyticsMailer::Interceptor

  # Custom header used to store computed analytics parameters
  PARAMS_HEADER = 'X-GA-Params'.freeze
  # Custom header used to report generator action mailer class
  CLASS_HEADER = 'X-ActionMailer'.freeze

  class << self

    # Interceptor interface, receive an email object and can modify it
    # @param [Mail::Message] email the email message
    def delivering_email(email)
      extract_params(email) do |params, klass|
        # Inject GA link parameters in the message
        GoogleAnalyticsMailer::Injector.new(email, params, klass).process!
      end
    end

    # Produce a valid serialization for email headers according to RFC822
    # @return [String] serialized value
    def dump(value)
      Base64.encode64(Marshal.dump(value))
    end

    def load(value)
      Marshal.load(Base64.decode64(value))
    end

    private

    # Take care of extracting GA parameters and remove the custom header
    # @yieldparam [Hash] params google analytics params
    # @yieldparam [ActionMailer::Base] klass class that generated this email
    def extract_params(email)
      params, klass = email.header[PARAMS_HEADER], email.header[CLASS_HEADER]
      # Remove custom headers from the message and yield if header found
      if params
        email.header[PARAMS_HEADER] = nil
        email.header[CLASS_HEADER] = nil
        yield load(params.value).with_indifferent_access, load(klass.value)
      end
    end

  end

end