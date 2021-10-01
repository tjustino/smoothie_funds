# frozen_string_literal: true

require "fileutils"
require "json"
require "open-uri"
require "pathname"
require "rubygems/package"
require "stringio"
require "zlib"

def get_last_version_of(opt)
  info_uri = URI.parse("https://api.github.com/repos/#{opt[:github_user]}/#{opt[:github_repo]}/releases/latest")
  last_version_uri = JSON.parse(info_uri.open.read)["tarball_url"]
  tgz_file = URI.parse(last_version_uri).open

  if opt[:scss_folder]
    local_scss_folder = Rails.root.join("vendor", "assets", "stylesheets", opt[:github_repo])
    FileUtils.remove_dir(local_scss_folder) if Dir.exist?(local_scss_folder)
    Dir.mkdir(local_scss_folder)
  end

  tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.new(tgz_file))
  tar_extract.rewind # The extract has to be rewinded after every iteration
  tar_extract.each do |entry|
    current_path = Pathname.new(entry.full_name).each_filename.to_a.drop(1)
    # deal with js file
    if opt[:js_file] && current_path.last.eql?(opt[:js_file])
      local_js_file = Rails.root.join("vendor", "assets", "javascripts", opt[:js_file])
      File.write(local_js_file, entry.read.encode("UTF-8", replace: "?"))
    # deal with scss folder
    elsif opt[:scss_folder] && current_path.first == opt[:scss_folder]
      scss_path = Rails.root.join("vendor", "assets", "stylesheets", opt[:github_repo], current_path.drop(1).join("/"))
      entry.directory? ? FileUtils.mkdir_p(scss_path) : File.write(scss_path, entry.read)
    end
  end
  tar_extract.close
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
    opt = { js_file: "chart.js" }
    local_js_file = Rails.root.join("vendor", "assets", "javascripts", opt[:js_file])
    File.write(local_js_file, URI.parse("https://cdn.jsdelivr.net/npm/chart.js@latest/dist/chart.js").open.read)
  end

  desc "Update wNumb file"
  task wnumb: :environment do
    get_last_version_of(github_user: "leongersen", github_repo: "wnumb", js_file: "wNumb.js")
  end
end
