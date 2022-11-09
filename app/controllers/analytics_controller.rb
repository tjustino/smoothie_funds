# frozen_string_literal: true

# Analytics Controller
class AnalyticsController < ApplicationController
  # GET /users/:user_id/analytics
  def index
    account = if params[:account].nil?
                @accounts_with_categories.first
              else
                @current_user.accounts.where(id: params[:account].to_i).first
              end

    transactions_with_balances         = Transaction.active.with_balances_for(account).where(account_id: account)
    transactions_from_past_time_to_now = Transaction.select("twb.date", "twb.balance")
                                                    .from(transactions_with_balances, :twb)
                                                    .where("twb.date": past_time..Time.zone.today)

    @labels = []
    transactions_from_past_time_to_now.each { |transaction| @labels << transaction.date }

    @data = []
    transactions_from_past_time_to_now.each { |transaction| @data << transaction.balance.to_f }
  end

  private ##############################################################################################################

    def past_time
      Time.zone.today - 3.months
    end
end
