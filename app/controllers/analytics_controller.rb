# frozen_string_literal: true

# Analytics Controller
class AnalyticsController < ApplicationController
  # GET /users/:user_id/analytics
  def index
    @account_to_analyse = if @current_accounts.ids.include? params[:account_id].to_i
                            params[:account_id].to_i
                          else
                            @current_accounts.first.id
                          end

    @transactions = Transaction.active.where(account_id: @account_to_analyse)
  end
end
