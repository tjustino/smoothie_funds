# frozen_string_literal: true

namespace :assets do
  desc "Change webmanifest file due to Propshaft limitation"
  task :precompile => :environment do
    assets_path  = Rails.root.join("public/assets/")
    json_file    = assets_path.join(".manifest.json")
    json_content = JSON.parse(File.read(json_file))
    
    old_192 = "android-chrome-192x192.png"
    old_512 = "android-chrome-512x512.png"
    new_192 = json_content[old_192]
    new_512 = json_content[old_512]
    target_file = assets_path.join(json_content["site.webmanifest"])
    
    new_content = File.read(target_file).gsub(old_192, new_192).gsub(old_512, new_512)
    File.write(target_file, new_content)    
  end
end


