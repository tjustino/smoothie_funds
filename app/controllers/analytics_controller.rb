class AnalyticsController < ApplicationController
  # GET /users/:user_id/analytics
  def index
    @transactions = Transaction.active.where(account_id: @current_accounts.ids)
  end
end
