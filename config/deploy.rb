# capistrano
set :application,   "smoothiefunds"
set :repo_url,      "git@github.com:tjustino/smoothie_funds.git"
set :deploy_to,     "/home/app/#{fetch(:application)}"
set :linked_files,  fetch(:linked_files, []).push(  "config/database.yml",
                                                    "config/secrets.yml" )
set :linked_dirs,   fetch(:linked_dirs, []).push(   "bin",
                                                    "log",
                                                    "tmp/pids",
                                                    "tmp/cache",
                                                    "tmp/sockets",
                                                    "vendor/bundle",
                                                    "public/system" )

# capistrano-rbenv
set :rbenv_type,      :user
set :rbenv_ruby,      "2.3.3"
set :rbenv_prefix,    "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins,  %w{rake gem bundle ruby rails}
