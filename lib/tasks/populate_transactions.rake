# frozen_string_literal: true

namespace :populate do
  desc "Create #{@many} transactions only for the first account not hidden"
  task transactions: :environment do
    @account = User.where(name: @name)
                   .first
                   .accounts
                   .where(hidden: false)
                   .order_by_name
                   .first
    @many.times do
      Transaction.create(
        account:  @account,
        category: @account.categories.sample,
        date:     Time.zone.now + rand(-60..10).days,
        amount:   rand(-100..100),
        checked:  rand(0..1) == 1,
        comment:  rand(0..1) == 1 ? SecureRandom.base58(20) : nil
      )
    end
  end
end
