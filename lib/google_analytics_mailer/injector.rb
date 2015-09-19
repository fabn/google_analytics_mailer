# This class is used to do the actual parameter injection in email links
class GoogleAnalyticsMailer::Injector

  attr_reader :email, :params

  # Build an injector
  # @param [Mail::Message] email the message to process
  # @param [HashWithIndifferentAccess] params GA params
  # @param [ActionMailer::Base] mailer message originator
  def initialize(email, params, mailer)
    @email = email
    @params = params
    @builder = GoogleAnalyticsMailer::UriBuilder.new(mailer.google_analytics_filter)
  end

  # Process the message by replacing url in body appending configured analytics parameters
  def process!
    # Replace links in all html parts of a message
    process_html_part do |doc|
      rewrite!(doc) { |a| @builder.build(a[:href], params.dup) }
    end
  end

  private

  # Yield a nokogiri document with the message html part and replace it with
  # the processed document.
  #
  # @yieldparam [Nokogiri::HTML::Document] nokogiri document that represents the html part
  def process_html_part(&block)
    body = email.multipart? ? email.html_part.body : email.body
    document = Nokogiri::HTML(body.raw_source)
    block.call(document)
    # Replace the html part with the processed document
    body.raw_source.replace(document.to_s)
  end

  # Update link content in nokogiri document
  # @param [Nokogiri::HTML::Document] document html document to update
  # @yield A block used to perform url transformations
  # @yieldparam [Nokogiri::XML::Element] nokogiri node representing a link
  def rewrite!(document, &block)
    document.css('a[href]').each do |link|
      link[:href] = block.call(link)
    end
  end

end