# frozen_string_literal: true

# Dashboard Helper
module DashboardHelper
  def sum_today(current_transactions, account)
    current_transactions.where(account: account).sum(:amount) + account.initial_balance
  end

  def current_balance(current_transactions, account)
    number_to_currency(sum_today(current_transactions, account))
  end

  def initial_balance(account)
    number_to_currency(account.initial_balance)
  end

  def today
    l(Date.current)
  end

  def current_date(current_transactions, account)
    max_date = current_transactions.where(account: account).maximum(:date)
    max_date.nil? ? l(Time.zone.today) : l(max_date)
  end

  def sum_tomorrow(transactions, account)
    transactions.where(account: account).sum(:amount) + account.initial_balance
  end

  def future_balance(transactions, account)
    number_to_currency(sum_tomorrow(transactions, account))
  end

  def future_date(transactions, account)
    l(transactions.where(account: account).maximum(:date))
  end

  def future_transactions?(transactions, account)
    transactions.where(account: account).where("date > ?", Time.zone.now).any?
  end

  def shedules_for(schedules, account)
    schedules.where(account: account)
  end
end
