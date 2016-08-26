# app - the Rails application itself
# db  - the database
# web - the nginx server that will act as a proxy and serve static assets
set     :stage,     :production
set     :rails_env, :production
server  "vps193113.ovh.net", user: "app", roles: %w{web app db}