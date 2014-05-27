class DashboardController < ApplicationController
  def index
    @credits  = Hash.new
    @debits   = Hash.new

    today = Time.now.end_of_day.to_formatted_s(:db)
    past_days = Time.now.months_ago(1).beginning_of_day.to_formatted_s(:db)

    @current_accounts.each do |account|
      @credits[account.id] = account.transactions.where(["amount > 0 and date >= ? and date <= ?", past_days, today]).sum(:amount)
      @debits[account.id]  = account.transactions.where(["amount < 0 and date >= ? and date <= ?", past_days, today]).sum(:amount)
    end
  end
end
