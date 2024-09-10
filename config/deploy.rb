# frozen_string_literal: true

set :application, "smoothiefunds"
set :repo_url,    "git@github.com:tjustino/smoothie_funds.git"
set :branch,      "main"
set :deploy_to,   "/srv/http/#{fetch(:application)}"

# files/dirs we want symlinking to shared
append :linked_dirs, ".bundle", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/assets"

# setup rbenv
set :rbenv_type,     :user
set :rbenv_ruby,     RUBY_VERSION
set :rbenv_prefix,   "RBENV_ROOT=#{fetch(:rbenv_path)} " \
                     "RBENV_VERSION=#{fetch(:rbenv_ruby)} " \
                     "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails puma pumactl]

# how many old releases do we want to keep
set :keep_releases, 3
set :keep_assets,   3
