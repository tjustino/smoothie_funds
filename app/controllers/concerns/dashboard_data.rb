# DashboardData for Dashboard and Schedules Controllers
module DashboardData
  private

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
end
