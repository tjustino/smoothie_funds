# frozen_string_literal: true

require "fileutils"
require "json"
require "open-uri"
require "pathname"
require "rubygems/package"
require "zlib"

def get_last_version_of(opt)
  info_uri = URI.parse("https://api.github.com/repos/#{opt[:github_user]}/#{opt[:github_repo]}/releases/latest")

  last_version_uri = if opt.include?(:download_url)
                       JSON.parse(info_uri.open.read)["assets"].first[opt[:download_url]]
                     else
                       JSON.parse(info_uri.open.read)["tarball_url"]
                     end

  tgz_file = URI.parse(last_version_uri).open

  [opt[:scss_folder], opt[:font_folder]].compact.each do |folder|
    folder_type = folder == opt[:scss_folder] ? "stylesheets" : "fonts"
    local_folder = Rails.root.join("vendor", "assets", folder_type, opt[:github_repo].downcase)
    FileUtils.remove_dir(local_folder) if Dir.exist?(local_folder)
    Dir.mkdir(local_folder)
  end

  tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.new(tgz_file))
  tar_extract.rewind # The extract has to be rewinded after every iteration
  tar_extract.each do |entry|
    path = Pathname.new(entry.full_name).each_filename.to_a.drop(1)
    # deal with js file
    if opt[:js_file] && path.last.eql?(opt[:js_file])
      local_js_file = Rails.root.join("vendor", "assets", "javascripts", opt[:js_file])
      File.binwrite(local_js_file, entry.read)
    # deal with scss folder
    elsif opt[:scss_folder] && path.first == opt[:scss_folder]
      scss_path = Rails.root.join("vendor", "assets", "stylesheets", opt[:github_repo].downcase, path.drop(1).join("/"))
      entry.directory? ? FileUtils.mkdir_p(scss_path) : File.binwrite(scss_path, entry.read)
    elsif opt[:font_folder] && path.first == opt[:font_folder]
      font_path = Rails.root.join("vendor", "assets", "fonts", opt[:github_repo].downcase, path.drop(1).join("/"))
      entry.directory? ? FileUtils.mkdir_p(font_path) : File.binwrite(font_path, entry.read)
    end
  end
  tar_extract.close
end

namespace :update_assets do
  desc "Update third party assets"
  task all: :environment do
    Rake::Task["update_assets:bootstrap"].invoke
    Rake::Task["update_assets:fontawesome"].invoke
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

  desc "Update Font Awesome font and scss files"
  task fontawesome: :environment do
    get_last_version_of(github_user: "FortAwesome",
                        github_repo: "Font-Awesome",
                        font_folder: "webfonts",
                        scss_folder: "scss")
  end

  desc "Update Chart.js file"
  task chartjs: :environment do
    get_last_version_of(github_user:  "chartjs",
                        github_repo:  "Chart.js",
                        download_url: "browser_download_url",
                        js_file:      "chart.js")
  end

  desc "Update wNumb file"
  task wnumb: :environment do
    get_last_version_of(github_user: "leongersen", github_repo: "wnumb", js_file: "wNumb.js")
  end
end
