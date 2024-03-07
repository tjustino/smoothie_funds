# frozen_string_literal: true

desc "Cleanup all your repository"

# Add some colors to String class
# Thanks to https://stackoverflow.com/a/11482430
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def green
    colorize(32)
  end

  def light_blue
    colorize(36)
  end
end

desc "Cleanup your environment"
task cleanup: :environment do
  Rake::Task["assets:clobber"].invoke
  puts "Old compiled assets removed 👍".green

  Rake::Task["log:clear"].invoke
  puts "Log files from log/ truncated to zero bytes 👍".green

  Rake::Task["tmp:clear"].invoke
  puts "Cache, socket and screenshot files from tmp/ cleared 👍".green

  system("git gc --auto")
  puts "git repository cleaned up 👍".green

  puts "Your repository take #{`du -hs .`}".light_blue
end
