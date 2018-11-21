# frozen_string_literal: true

source  "https://rubygems.org"
ruby    "2.5.3"

## from http://bundler.io/gemfile.html
# ~> 2.0.3 is identical to >= 2.0.3 and < 2.1
# ~> 2.1 is identical to >= 2.1 and < 3.0
# ~> 2.2.beta will match prerelease versions like 2.2.beta.12

gem "bcrypt",       "~> 3.1.7"  # Use ActiveModel has_secure_password
gem "bootsnap", require: false  # Reduces boot times through caching
gem "bootstrap"                 # Twitter's Bootstrap
gem "chart-js-rails"            # Chart.js for use in Rails asset pipeline
gem "coffee-rails", "~> 4.2"    # Use CoffeeScript for .coffee assets and views
gem "font-awesome-rails"        # Iconic font and CSS toolkit
gem "jquery-rails"              # Use jquery as the JavaScript library
# gem "mailgun-rails"           # Mailgun adapter for Rails
gem "pg"                        # Use postgresql as the db for Active Record
gem "puma",         "~> 3.11"   # App web server
gem "rails",        "~> 5.2.1"  # Full-stack web framework
gem "sass-rails",   "~> 5.0"    # Use SCSS for stylesheets
gem "slim"                      # Template language
# gem "turbolinks",  "~> 5"     # Make following links in web application faster
gem "uglifier"                  # Use as compressor for JavaScript assets

group :development, :test do
  gem "byebug", platform: :mri  # Call 'byebug' anywhere in the code to stop it
  gem "capybara", "< 4.0"       # Integration testing tool
  gem "chromedriver-helper"     # Easy installation and use of chromedriver
  gem "selenium-webdriver"      # Tool for writing automated tests of websites
end

group :development do
  gem "annotate"                # Annotates ActiveRecord Model, route & fixture
  gem "listen", "< 3.2"         # Listen to file modif and notifies you
  gem "rubocop"                 # Automatic Ruby code style checking tool
  gem "spring"                  # Keep application running in the background
  gem "spring-watcher-listen", "~> 2.0.0" # Makes spring watch files
  gem "web-console"             # Access an IRB console on exception pages

  # Use Capistrano for deployment
  gem "capistrano-rails"
  gem "capistrano-rbenv"        # Idiomatic rbenv support for Capistrano 3
  gem "capistrano3-puma"        # Puma integration for Capistrano 3
end
