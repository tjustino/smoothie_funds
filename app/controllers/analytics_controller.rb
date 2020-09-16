# frozen_string_literal: true

# Analytics Controller
class AnalyticsController < ApplicationController
  # GET /users/:user_id/analytics
  def index
    @account_to_analyse = params[:account_id].nil? ? @current_accounts.first.id : params[:account_id].to_i
    @transactions = Transaction.active.where(account_id: @account_to_analyse)
  end
end
