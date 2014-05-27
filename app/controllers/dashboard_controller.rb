class DashboardController < ApplicationController
  def index
    @sum_credits  = Hash.new
    @sum_debits   = Hash.new

    today = Time.now.end_of_day.to_formatted_s(:db)
    past_days = Time.now.months_ago(1).beginning_of_day.to_formatted_s(:db)

    @current_accounts.each do |account|
      @sum_credits[account.id] = account.transactions.where(["amount > 0 and date >= ? and date <= ?", past_days, today]).sum(:amount)
      @sum_debits[account.id]  = account.transactions.where(["amount < 0 and date >= ? and date <= ?", past_days, today]).sum(:amount)
    end
  end
end
