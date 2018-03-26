# frozen_string_literal: true

set :application,   "smoothiefunds"

# setup repo
set :repo_url,      "git@github.com:tjustino/smoothie_funds.git"

# setup deploy details
set :deploy_to,     "/home/app/#{fetch(:application)}"

# files/dirs we want symlinking to shared
set :linked_files,  fetch(:linked_files, []).push("config/database.yml",
                                                  "config/secrets.yml")

set :linked_dirs,   fetch(:linked_dirs, []).push("bin",
                                                 "log",
                                                 "tmp/pids",
                                                 "tmp/cache",
                                                 "tmp/sockets",
                                                 "vendor/bundle",
                                                 "public/system")

# setup rbenv
set :rbenv_type,      :user
set :rbenv_ruby,      RUBY_VERSION
set :rbenv_prefix,    "RBENV_ROOT=#{fetch(:rbenv_path)} " \
                      "RBENV_VERSION=#{fetch(:rbenv_ruby)} " \
                      "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins,  %w[rake gem bundle ruby rails puma pumactl]

# how many old releases do we want to keep
set :keep_releases, 5
