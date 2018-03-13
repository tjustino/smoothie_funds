namespace :populate do
  desc "Create #{MANY} schedules only for the first account not hidden"
  task schedules: :environment do
    @account = User.where(name: NAME)
                   .first
                   .accounts
                   .where(hidden: false)
                   .order_by_name
                   .first
    MANY.times do
      Schedule.create(account:    @account,
                      next_time:  Time.zone.now + rand(1..60).days,
                      frequency:  rand(1..10),
                      period:     %w[days weeks months years].sample,
                      operation_attributes:
                        { account:  @account,
                          amount:   rand(-100..100),
                          category: @account.categories.sample,
                          comment:  \
                                rand(0..1) == 1 ? SecureRandom.base58(20) : nil,
                          checked:  rand(0..1) == 1 })
    end
  end
end
