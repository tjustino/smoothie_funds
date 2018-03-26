# frozen_string_literal: true

namespace :populate do
  desc "Create #{MANY} categories only for the first account not hidden"
  task categories: :environment do
    @account = User.where(name: NAME)
                   .first
                   .accounts
                   .where(hidden: false)
                   .order_by_name
                   .first
    MANY.times do
      Category.create(account: @account, name: SecureRandom.base58(10))
    end
  end
end
