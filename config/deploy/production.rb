# frozen_string_literal: true

# app - the Rails application itself
# db  - the database
# web - the nginx server that will act as a proxy and serve static assets
set    :stage,     :production
set    :rails_env, :production
server "smoothiefunds.com", ssh_options: { user: "app", auth_methods: ["publickey"] }, roles: %w[web app db]
