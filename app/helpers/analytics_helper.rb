# frozen_string_literal: true

# Analytics Helper
module AnalyticsHelper
  def dates_before_past_time(account, transactions)
    transactions_from_past_time_to_now(account, transactions).keys.map { |date| l(date).as_json }.join(",")
  end

  def past_data(account, transactions)
    data = transactions_from_past_time_to_now(account, transactions).values
    data.each_with_index do |amount, index|
      if index.zero?
        data[index] += balance_before_past_time(account, transactions)
      else
        data[index] = data[index - 1] + amount
      end
    end
    data.map(&:to_f).join(",")
  end

  def balance_before_past_time(account, transactions)
    Account.find(account.id).initial_balance + transactions
                                               .where(account: account)
                                               .where("date < ?", past_time)
                                               .sum(:amount)
  end

  def transactions_from_past_time_to_now(account, transactions)
    transactions.where(account: account)
                .where("date >= ?", past_time)
                .where("date <= ?", Time.zone.now.midnight)
                .group(:date)
                .order(date: :asc) # must be before sum
                .sum(:amount)
  end

  # def futur_data(account)
  #   @transactions.where(account: account).where("date > ?", Time.now.midnight)
  #                                         .order(date: :asc, id: :asc)
  # end

  def past_time
    -3.months.from_now.midnight
  end
end
