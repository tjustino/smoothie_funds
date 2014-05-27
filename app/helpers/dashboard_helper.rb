module DashboardHelper
  def debit_percent(account)
    ((100 * @sum_debits[account.id].abs) / @sum_credits[account.id]).to_i
  end

  def credit_percent(account)
    100 - ((100 * @sum_debits[account.id].abs) / @sum_credits[account.id]).to_i
  end
end
