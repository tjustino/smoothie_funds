class DashboardController < ApplicationController
  include DashboardData

  # GET /
  def index
    load_transactions
    load_current_transactions
    load_schedules
    load_pendings
  end

  private ##############################################################################################################

    def load_pendings
      @pendings = PendingUser.where(email: @current_user.email)
    end
end
