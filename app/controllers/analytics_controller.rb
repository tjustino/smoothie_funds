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

    transactions_from_past_time_to_now = Transaction.active
                                                    .where(account_id: account.id)
                                                    .where("date >= ?", past_time)
                                                    .where("date <= ?", Time.zone.now.midnight)
                                                    .group(:date)
                                                    .order(date: :asc) # must be before sum
                                                    .sum(:amount)

    @labels = []
    transactions_from_past_time_to_now.each_key { |key| @labels << key }

    @data = transactions_from_past_time_to_now.values.map(&:to_f)
    @data.each_with_index do |amount, index|
      @data[index] = if index.zero?
                       Account.find(account.id).initial_balance + amount
                     else
                       @data[index - 1] + amount
                     end
    end
  end

  private ##############################################################################################################

    def past_time
      -3.months.from_now.midnight
    end
end
