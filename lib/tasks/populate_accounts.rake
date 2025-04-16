namespace :populate do
  desc "Create #{@many} accounts"
  task accounts: :environment do
    @user = User.where(name: @name).first

    @many.times do
      account = Account.create(name:            SecureRandom.base58(10),
                               initial_balance: rand(-1000..1000),
                               hidden:          rand(0..1) == 1)
      account.users << @user
    end
  end
end
