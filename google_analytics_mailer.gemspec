# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_analytics_mailer/version'

Gem::Specification.new do |gem|
  gem.name          = 'google_analytics_mailer'
  gem.version       = GoogleAnalyticsMailer::VERSION
  gem.authors       = ['Fabio Napoleoni']
  gem.email         = ['f.napoleoni@gmail.com']
  gem.description   = %q{This gem add google analytics campaign tags to every link in your action mailer}
  gem.summary       = %q{This gem provides automatic Google Analytics tagged links in ActionMailer generated emails}
  gem.homepage      = 'https://github.com/fabn/google_analytics_mailer'
  gem.license       = 'MIT'
  gem.required_ruby_version = '>= 2.0.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # gem dependencies for runtime
  gem.add_runtime_dependency 'addressable', '~> 2.3.0'
  gem.add_runtime_dependency 'actionmailer', '>= 3.2.0'
end
