# frozen_string_literal: true

namespace :populate do
  desc "Create #{@many} schedules only for the first account not hidden"
  task schedules: :environment do
    @account = User.where(name: @name)
                   .first
                   .accounts
                   .where(hidden: false)
                   .order_by_name
                   .first
    @many.times do
      Schedule.create(account:              @account,
                      next_time:            Time.zone.now + rand(1..60).days,
                      frequency:            rand(1..10),
                      period:               %w[days weeks months years].sample,
                      operation_attributes: {
                        account:  @account,
                        amount:   rand(-100..100),
                        category: @account.categories.sample,
                        comment:  rand(0..1) == 1 ? SecureRandom.hex : nil,
                        checked:  rand(0..1) == 1
                      })
    end
  end
end
