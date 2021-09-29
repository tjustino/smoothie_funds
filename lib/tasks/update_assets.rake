# frozen_string_literal: true

require "fileutils"
require "json"
require "open-uri"
require "stringio"
require "zip"

def get_last_version_of(opt)
  info_uri = URI.parse("https://api.github.com/repos/#{opt[:github_user]}/#{opt[:github_repo]}/releases/latest")
  last_version_uri = JSON.parse(info_uri.open.read)["zipball_url"]
  zip_file = StringIO.new(URI.parse(last_version_uri).open.read)

  if opt[:scss_folder]
    local_scss_folder = Rails.root.join("vendor", "assets", "stylesheets", opt[:github_repo])
    FileUtils.remove_dir(local_scss_folder) if Dir.exist?(local_scss_folder)
    Dir.mkdir(local_scss_folder)
  end

  zip_stream = Zip::InputStream.new(zip_file)
  while (entry = zip_stream.get_next_entry)
    current_path = Pathname.new(entry.name).each_filename.to_a.drop(1)
    # deal with js file
    if opt[:js_file] && entry.name.end_with?(opt[:js_file])
      local_js_file = Rails.root.join("vendor", "assets", "javascripts", opt[:js_file])
      FileUtils.remove_file(local_js_file) if File.exist?(local_js_file)
      entry.extract(local_js_file)
    # deal with scss folder
    elsif opt[:scss_folder] && current_path.first == opt[:scss_folder]
      scss_path = Rails.root.join("vendor", "assets", "stylesheets", opt[:github_repo], current_path.drop(1).join("/"))
      if entry.name_is_directory?
        FileUtils.mkdir_p(scss_path)
      else
        entry.extract(scss_path)
      end
    end
  end
end

namespace :update_assets do
  desc "Update third party assets"
  task all: :environment do
    Rake::Task["update_assets:bootstrap"].invoke
    Rake::Task["update_assets:chartjs"].invoke
    Rake::Task["update_assets:wnumb"].invoke
  end

  desc "Update Bootstrap js and scss files"
  task bootstrap: :environment do
    get_last_version_of(github_user: "twbs",
                        github_repo: "bootstrap",
                        js_file:     "bootstrap.bundle.js",
                        scss_folder: "scss")
  end

  desc "Update Chart.js file"
  task chartjs: :environment do
    # get_last_version_of(github_user: "chartjs", github_repo: "Chart.js", js_file: "chart.js")
    # KO → need the zlib gem and deal with browser_download_url
    local_js_file = Rails.root.join("vendor", "assets", "javascripts", "chart.js")
    File.open(local_js_file, "w") do |file|
      file.write URI.parse("https://cdn.jsdelivr.net/npm/chart.js@latest/dist/chart.js").open.read
    end
  end

  desc "Update wNumb file"
  task wnumb: :environment do
    get_last_version_of(github_user: "leongersen", github_repo: "wnumb", js_file: "wNumb.js")
  end
end
