# frozen_string_literal: true

# Dashboard Helper
module DashboardHelper
  def sum_today(account)
    @current_transactions.where(account: account).sum(:amount) +
      account.initial_balance
  end

  def current_balance(account)
    number_to_currency(sum_today(account))
  end

  def initial_balance(account)
    number_to_currency(account.initial_balance)
  end

  def today
    l(Date.current)
  end

  def current_date(account)
    max_date = @current_transactions.where(account: account).maximum(:date)
    max_date.nil? ? l(Time.zone.today) : l(max_date)
  end

  def sum_tomorrow(account)
    @transactions.where(account: account).sum(:amount) + account.initial_balance
  end

  def future_balance(account)
    number_to_currency(sum_tomorrow(account))
  end

  def future_date(account)
    l(@transactions.where(account: account).maximum(:date))
  end

  def future_transactions?(account)
    @transactions.where(account: account).where("date > ?", Time.zone.now).any?
  end

  def shedules_for(account)
    @schedules.where(account: account)
  end
end
