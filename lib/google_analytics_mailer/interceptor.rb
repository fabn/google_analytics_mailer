# This class is used as mail interceptor to detect GA configuration and to trigger
# parameters injection.
class GoogleAnalyticsMailer::Interceptor

  # Custom header used to store computed analytics parameters
  HEADER_NAME = 'X-GA-Params'.freeze

  class << self

    # Interceptor interface, receive an email object and can modify it
    # @param [Mail::Message] email the email message
    def delivering_email(email)
      extract_params(email).tap do |params|
        inject_params(email, params) if params
      end
    end

    private

    # Inject GA link parameters in the message
    def inject_params(email, params)
      GoogleAnalyticsMailer::Injector.new(email, params).process!
    end

    # Take care of extracting GA parameters and remove the custom header
    # @return [Hash] extracted params or nil if none
    def extract_params(email)
      params = email.header[HEADER_NAME]
      # Remove the header from the message and return unserialized params
      if params
        email.header[HEADER_NAME] = nil
        JSON.load(params.value)
      end
    end

  end


end