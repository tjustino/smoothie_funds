class AnalyticsController < ApplicationController
  # GET /users/:user_id/analytics
  def index
    set_accounts_with_categories
    @transactions = 
            Transaction.active.where(account_id: @accounts_with_categories.ids)
  end
end
