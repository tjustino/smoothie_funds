# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker buildx build --tag smoothiefunds .
# docker run -d -p 80:80 -p 443:443 --name my-app -e RAILS_MASTER_KEY=<value from config/master.key> my-app
# docker run --rm --name smoothiefunds --publish 80:80 --env RAILS_MASTER_KEY=<value from config/master.key> smoothiefunds

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.7
FROM ruby:${RUBY_VERSION}-alpine

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="test:development"

# App lives here
WORKDIR /srv/http/smoothiefunds

# Install application gems
COPY Gemfile Gemfile.lock .ruby-version .
RUN apk update && \
    apk upgrade && \
    rm -rf /var/cache/apk/* && \
    # Required package for bundle
    apk --no-cache --virtual .ruby_deps add build-base yaml-dev && \
    bundle install && \
    rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache && \
    apk del .ruby_deps && \
    # Essential everyday package
    apk --no-cache add bash jemalloc && \
    # Run and own files as a non-root user for security
    chgrp -R www-data /srv/http/smoothiefunds/ && \
    adduser -S -D -G www-data -s /bin/bash webapp

# Copy application code
COPY --chown=webapp:www-data . .

# Use this default user and group for subsequent RUN, ENTRYPOINT and CMD commands
USER webapp:www-data

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile --trace

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
