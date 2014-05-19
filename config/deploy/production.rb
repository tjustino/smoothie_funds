set :stage,     :production
set :branch,    "master"
set :rails_env, :production

set :server_name, "www.smoothiefunds.com smoothiefunds.com"
set :enable_ssl,  false

server "smoothiefunds.com", user: "www", roles: %w{web app db}, primary: true
