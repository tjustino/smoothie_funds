namespace :populate do
  @many = 100
  @name = "Thomas"

  desc "Create #{@many} accounts, categories, schedules and transactions"
  task all: :environment do
    Rake::Task["populate:accounts"].invoke
    Rake::Task["populate:categories"].invoke
    Rake::Task["populate:schedules"].invoke
    Rake::Task["populate:transactions"].invoke
  end
end
