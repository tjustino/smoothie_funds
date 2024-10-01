# frozen_string_literal: true

source  "https://rubygems.org"
ruby    "3.3.5"

## from http://bundler.io/gemfile.html
# ~> 2.0.3 is identical to >= 2.0.3 and < 2.1
# ~> 2.1 is identical to >= 2.1 and < 3.0
# ~> 2.2.beta will match prerelease versions like 2.2.beta.12

gem "bcrypt"                   # Use ActiveModel has_secure_password
gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "importmap-rails"          # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "dartsass-rails"           # Integrate Dart Sass with the asset pipeline in Rails
gem "sass-embedded", "< 1.77.7" # Dart Sass breaking change [https://github.com/jgthms/bulma/issues/3864]
gem "pg"                       # Use postgresql as the db for Active Record
gem "propshaft"                # Deliver assets for Rails
gem "puma"                     # App web server
gem "rails", "~> 7.2.0"        # Full-stack web framework
gem "stimulus-rails"           # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "turbo-rails"              # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "tzinfo-data", platforms: %i[windows jruby] # Windows does not include zoneinfo files
gem "write_xlsx"               # Create new file in the Excel 2007+ XLSX format

group :development, :test do
  gem "debug", platforms: %i[mri windows] # Start debugger with binding.break
end

group :development do
  gem "brakeman"               # Security vulnerability scanner for Ruby on Rails
  gem "bundler-audit"          # Provides patch-level verification for Bundled apps
  gem "foreman"                # Process manager for applications with multiple components
  gem "listen"                 # Listen to file modif and notifies you
  # gem "rack-mini-profiler"     # Add speed badges
  # gem "web-console"            # Access an IRB console on exception pages

  # Rubocop
  gem "rubocop"                # Automatic Ruby code style checking tool
  gem "rubocop-minitest"       # Extension focused on Minitest best practices
  gem "rubocop-performance"    # Check for performance optimizations
  gem "rubocop-rails"          # Automatic Rails code style checking tool
  gem "rubocop-rake"           # RuboCop plugin for Rake
  gem "rubocop-rails-omakase"  # Omakase Ruby styling for Rails

  # Capistrano
  gem "capistrano"             # Execute commands in parallel on remote machine
  gem "capistrano-bundler"     # Bundler specific tasks for Capistrano v3
  gem "capistrano-rails"       # Rails specific Capistrano tasks
  gem "capistrano-rbenv"       # Idiomatic rbenv support for Capistrano 3
end
