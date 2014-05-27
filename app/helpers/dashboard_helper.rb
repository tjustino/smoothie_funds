module DashboardHelper
  def debit_percent(account)
    ((100 * @debits[account.id].abs) / @credits[account.id]).to_i
  end

  def credit_percent(account)
    100 - ((100 * @debits[account.id].abs) / @credits[account.id]).to_i
  end
end
