# This class is used to do the actual parameter injection in email links
class GoogleAnalyticsMailer::Injector

  attr_reader :email, :params

  def initialize(email, params)
    @email = email
    @params = params.dup.freeze
  end

  def process!
    # TODO complete
  end

end