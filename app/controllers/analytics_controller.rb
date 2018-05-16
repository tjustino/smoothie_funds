# frozen_string_literal: true

# Analytics Controller
class AnalyticsController < ApplicationController
  # GET /users/:user_id/analytics
  def index
    @transactions = Transaction.active
                               .where(account_id: @accounts_with_categories.ids)
  end
end
