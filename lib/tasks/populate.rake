namespace :populate do
  MANY = 50
  NAME = "Thomas"

  desc "Create #{MANY.to_s} accounts"
  task accounts: :environment do
    @user = User.where(name: NAME).first

    MANY.times do
      account = Account.create( name:            SecureRandom.base58(10),
                                initial_balance: rand(-1000..1000),
                                hidden:          rand(0..1) == 1 ? true : false)
      account.users << @user
    end
  end

  desc "Create #{MANY.to_s} categories only for the first account not hidden"
  task categories: :environment do
    @account = User.where(name: NAME).first.accounts.where(hidden: false)
                                                    .order_by_name.first
    MANY.times do
      Category.create( account: @account, name: SecureRandom.base58(10) )
    end
  end

  desc "Create #{MANY.to_s} schedules only for the first account not hidden"
  task schedules: :environment do
    @account = User.where(name: NAME).first.accounts.where(hidden: false)
                                                    .order_by_name.first
    MANY.times do
      Schedule.create(account:    @account,
                      next_time:  DateTime.now + rand(1..60).days,
                      frequency:  rand(1..10),
                      period:     ["days", "weeks", "months", "years"].sample,
                      operation_attributes: { account:  @account,
                                              amount:   rand(-100..100),
                                              category: @account.categories.sample,
                                              comment:  rand(0..1) == 1 ? SecureRandom.base58(20) : nil,
                                              checked:  rand(0..1) == 1 ? true : false } )
    end
  end

  desc "Create #{MANY.to_s} transactions only for the first account not hidden"
  task transactions: :environment do
    @account = User.where(name: NAME).first.accounts.where(hidden: false)
                                                    .order_by_name.first
    MANY.times do
      Transaction.create( account:  @account,
                          category: @account.categories.sample,
                          date:     DateTime.now + rand(-60..10).days,
                          amount:   rand(-100..100),
                          checked:  rand(0..1) == 1 ? true : false,
                          comment:  rand(0..1) == 1 ? SecureRandom.base58(20) : nil )
    end
  end
end
