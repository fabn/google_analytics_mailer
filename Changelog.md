Not released changes

## 0.2.1, released 2014-11-06

* Testing support for ActionMailer 4.1

## 0.2.0, released 2013-09-28

* Inserted rspec-rails as development dependency to allow easier testing of helper methods
* Now view helpers use output buffering to allow inline usage. It means that they must be used with equal sign in ERB templates
* Allow disabling gem for a block of code with helper `without_google_analytics_params`
* Allow usage also in controllers since they have the same structure of `ActionMailer::Base`
* Extracted uri parser in its own class

## 0.1.2, released 2013-09-26

* Removed blank params from generated urls

## 0.1.1, released 2013-08-23

* Added license to gemspec

## 0.1.0, released 2013-08-22

* ActionMailer 4.0 support
* Travis integration

## 0.0.1, released 2013-01-28

* Initial version