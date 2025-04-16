namespace :populate do
  desc "Create #{@many} categories only for the first account not hidden"
  task categories: :environment do
    @account = User.where(name: @name)
                   .first
                   .accounts
                   .where(hidden: false)
                   .order_by_name
                   .first
    @many.times do
      Category.create(account: @account, name: SecureRandom.base58(10))
    end
  end
end
