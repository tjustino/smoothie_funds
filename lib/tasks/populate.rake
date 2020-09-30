# frozen_string_literal: true

MANY = 100
NAME = "Thomas"

namespace :populate do
  desc "Create #{MANY} accounts, categories, schedules and transactions"
  task all: :environment do
    Rake::Task["populate:accounts"].invoke
    Rake::Task["populate:categories"].invoke
    Rake::Task["populate:schedules"].invoke
    Rake::Task["populate:transactions"].invoke
  end
end
