# frozen_string_literal: true

# Schedules Helper
module SchedulesHelper
  def easy_t(period)
    case period
    when "days"   then t(".days")
    when "weeks"  then t(".weeks")
    when "months" then t(".months")
    when "years"  then t(".years")
    end
  end
end
