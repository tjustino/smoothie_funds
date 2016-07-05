source 'https://rubygems.org'

## from http://bundler.io/gemfile.html
# ~> 2.0.3 is identical to >= 2.0.3 and < 2.1
# ~> 2.1 is identical to >= 2.1 and < 3.0
# ~> 2.2.beta will match prerelease versions like 2.2.beta.12

gem "rails",        "~> 5.0.0"

gem "pg"                        # Use postgresql as the db for Active Record
#gem "redis",        "~> 3.0"    # Use Redis adapter to run Action Cable in prod
gem "sass-rails",   "~> 5.0"    # Use SCSS for stylesheets
gem "uglifier",     ">= 1.3.0"  # Use as compressor for JavaScript assets
gem "coffee-rails", "~> 4.2"    # Use CoffeeScript for .coffee assets and views
gem "jquery-rails"              # Use jquery as the JavaScript library
#gem "turbolinks",   "~> 5"     # Make following links in web application faster
#gem "jbuilder",     "~> 2.5"   # Build JSON APIs with ease
gem "bcrypt",       "~> 3.1.7"  # Use ActiveModel has_secure_password

gem "puma",         "~> 3.0"    # App web server
gem "slim"                      # Template language
gem "bootstrap-sass"            # Twitter's Bootstrap, converted to Sass
gem "font-awesome-rails"        # Iconic font and CSS toolkit
gem "jquery-ui-rails"           # jQuery UI's packaged for Rails asset pipeline
#gem "mailgun-rails"             # Mailgun adapter for Rails

group :development, :test do
  gem "byebug", platform: :mri  # Call 'byebug' anywhere in the code to stop it
end

group :development do
  gem "spring"                  # Keep application running in the background
  gem "listen", "~> 3.0.5"      # Listen to file modifications and notifies you
  gem "spring-watcher-listen", "~> 2.0.0" # Makes spring watch files
  gem "web-console"             # Access an IRB console on exception pages
  gem "annotate"                # Annotates ActiveRecord Model, route & fixture
  gem "rails-erd"               # Generate an entity-relationship diagram (ERD)

  # Use Capistrano for deployment
  gem "capistrano"
  gem "capistrano-rails"
  gem "capistrano-bundler"
  gem "capistrano-rbenv"
end
