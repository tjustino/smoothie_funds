source  "https://rubygems.org"
ruby    "2.5.0"

## from http://bundler.io/gemfile.html
# ~> 2.0.3 is identical to >= 2.0.3 and < 2.1
# ~> 2.1 is identical to >= 2.1 and < 3.0
# ~> 2.2.beta will match prerelease versions like 2.2.beta.12

gem "rails",        "~> 5.1.4"
gem "puma",         "~> 3.7"    # App web server
gem "sass-rails",   "~> 5.0"    # Use SCSS for stylesheets
gem "uglifier"                  # Use as compressor for JavaScript assets
gem "coffee-rails", "~> 4.2"    # Use CoffeeScript for .coffee assets and views
#gem "turbolinks",  "~> 5"      # Make following links in web application faster
#gem "jbuilder",    "~> 2.5"    # Build JSON APIs with ease
#gem "redis",       "~> 3.0"    # Use Redis adapter to run Action Cable in prod
gem "bcrypt",       "~> 3.1.7"  # Use ActiveModel has_secure_password

gem "pg"                        # Use postgresql as the db for Active Record
gem "jquery-rails"              # Use jquery as the JavaScript library
gem "slim"                      # Template language
gem "bootstrap"                 # Twitter's Bootstrap
gem "font-awesome-rails"        # Iconic font and CSS toolkit
gem "chart-js-rails"            # Chart.js for use in Rails asset pipeline
#gem "mailgun-rails"            # Mailgun adapter for Rails

group :development, :test do
  gem "byebug", platform: :mri  # Call 'byebug' anywhere in the code to stop it
  gem "capybara", "~> 2.13"     # Integration testing tool
  gem "selenium-webdriver"      # Tool for writing automated tests of websites
end

group :development do
  gem "web-console"             # Access an IRB console on exception pages
  gem "listen", ">= 3.0.5", "< 3.2" # Listen to file modif and notifies you
  gem "spring"                  # Keep application running in the background
  gem "spring-watcher-listen", "~> 2.0.0" # Makes spring watch files

  gem "annotate"                # Annotates ActiveRecord Model, route & fixture
  #gem "rails-erd"              # Generate an entity-relationship diagram (ERD)

  # Use Capistrano for deployment
  gem "capistrano-rails"
  gem "capistrano-rbenv"        # Idiomatic rbenv support for Capistrano 3
  gem "capistrano3-puma"        # Puma integration for Capistrano 3
end
