# frozen_string_literal: true

source  "https://rubygems.org"
ruby    "3.0.1"

## from http://bundler.io/gemfile.html
# ~> 2.0.3 is identical to >= 2.0.3 and < 2.1
# ~> 2.1 is identical to >= 2.1 and < 3.0
# ~> 2.2.beta will match prerelease versions like 2.2.beta.12

gem "bcrypt"                    # Use ActiveModel has_secure_password
gem "bootsnap", require: false  # Reduces boot times through caching
gem "pg"                        # Use postgresql as the db for Active Record
gem "puma"                      # App web server
gem "rails",   "~> 6.1.0"       # Full-stack web framework
gem "sass-rails"                # Sass adapter for the Rails asset pipeline
gem "slim"                      # Template language
gem "sprockets"                 # compile and serve web assets

group :development, :test do
  gem "byebug"                  # Call 'byebug' anywhere in the code to stop it
  gem "capybara"                # Integration testing tool
  gem "selenium-webdriver"      # Tool for writing automated tests of websites
  gem "webdrivers"              # Easy installation and use of chromedriver
end

group :development do
  gem "annotate"                # Annotates ActiveRecord Model, route & fixture
  gem "listen"                  # Listen to file modif and notifies you
  gem "rubocop"                 # Automatic Ruby code style checking tool
  gem "rubocop-performance"     # Check for performance optimizations
  gem "rubocop-rails"           # Automatic Rails code style checking tool
  gem "spring"                  # Keep application running in the background
  gem "web-console"             # Access an IRB console on exception pages

  # Use Capistrano for deployment
  gem "capistrano"              # Execute commands in parallel on remote machine
  gem "capistrano-bundler"      # Bundler specific tasks for Capistrano v3
  gem "capistrano-rails"        # Rails specific Capistrano tasks
  gem "capistrano-rbenv"        # Idiomatic rbenv support for Capistrano 3
  gem "capistrano3-puma"        # Puma integration for Capistrano 3
end
