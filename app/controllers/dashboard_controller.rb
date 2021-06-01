# frozen_string_literal: true

# Dashboard Controller
class DashboardController < ApplicationController
  # GET /
  def index
    load_transactions
    load_current_transactions
    load_schedules
    load_pendings
  end

  private ######################################################################

    def load_transactions
      @transactions = Transaction.active.where(account_id: @current_accounts.ids)
    end

    def load_current_transactions
      @current_transactions = @transactions.where("date <= ?", Time.zone.now)
    end

    def load_schedules
      @schedules = Schedule.where(account_id: @current_accounts.ids)
                           .where("next_time <= ?", Time.zone.now.midnight + 30.days)
                           .order(next_time: :asc, id: :asc)
    end

    def load_pendings
      @pendings = PendingUser.where(email: @current_user.email)
    end
end
