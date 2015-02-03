module DashboardHelper
  def current_balance(account)
    number_to_currency( @current_transactions
                        .where(account: account)
                        .sum(:amount) + account.initial_balance )
  end

  def current_date(account)
    l( @current_transactions.where(account: account).maximum(:date) )
  end

  def future_balance(account)
    number_to_currency( @transactions.where(account: account)
                          .sum(:amount) + account.initial_balance )
  end

  def future_date(account)
    l( @transactions.where(account: account).maximum(:date) )
  end

  def future_transactions?(account)
    @transactions.where(account: account).where("date > ?", Time.now).any?
  end
end