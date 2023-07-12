# frozen_string_literal: true

namespace :assets do
  desc "Change webmanifest file due to Propshaft limitation"
  task precompile: :environment do
    assets_path  = Rails.public_path.join("assets")
    json_file    = assets_path.join(".manifest.json")
    json_content = JSON.parse(File.read(json_file))

    old192 = "android-chrome-192x192.png"
    old512 = "android-chrome-512x512.png"
    new192 = json_content[old192]
    new512 = json_content[old512]
    target_file = assets_path.join(json_content["site.webmanifest"])

    new_content = File.read(target_file).gsub(old192, new192).gsub(old512, new512)
    File.write(target_file, new_content)
  end
end
