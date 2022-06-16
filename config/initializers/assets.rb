# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Add support for site.webmanifest and browserconfig.xml with erb processor in the asset pipeline
Rails.application.config.assets.configure do |env|
  webmanifest_mime_type    = "application/manifest+json"
  webmanifest_extensions   = [".webmanifest"]
  browserconfig_mime_type  = "application/xml"
  browserconfig_extensions = [".xml"]

  if Sprockets::VERSION.to_i >= 4
    env.register_preprocessor(webmanifest_mime_type,   Sprockets::ERBProcessor)
    env.register_preprocessor(browserconfig_mime_type, Sprockets::ERBProcessor)
    webmanifest_extensions   << ".webmanifest.erb"
    browserconfig_extensions << ".xml.erb"
  end

  env.register_mime_type(webmanifest_mime_type,   extensions: webmanifest_extensions)
  env.register_mime_type(browserconfig_mime_type, extensions: browserconfig_extensions)
end
