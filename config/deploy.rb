set :application, "smoothiefunds"

# setup repo
set :scm,       :git
set :repo_url,  "git@github.com:tjustino/smoothie_funds.git"

# setup deploy details
set :deploy_user, "www"
set :deploy_to,   "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"

# setup ssh
set :ssh_options, { forward_agent: true }

# setup rbenv
set :rbenv_type,      :user
set :rbenv_ruby,      "2.1.5"
set :rbenv_prefix,    "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins,  %w{rake gem bundle ruby rails}

# files/dirs we want symlinking to shared
set :linked_files,  %w{config/database.yml config/secrets.yml}
set :linked_dirs,   %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# how many old releases do we want to keep
set :keep_releases, 5

namespace :deploy do

  COMMANDS = %w(start stop restart)

  COMMANDS.each do |command|
    task command do
      on roles(:app), in: :sequence, wait: 5 do
        within current_path do
          execute :bundle, "exec thin #{command} -O --tag '#{fetch(:application)} #{fetch(:stage)}' -C config/thin/#{fetch(:stage)}.yml"
        end
      end
    end
  end

  after :finishing, "deploy:cleanup"
end
