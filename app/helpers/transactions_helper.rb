# frozen_string_literal: true

# Transactions Helper
module TransactionsHelper
  def decoration_according_to_(transaction)
    if (transaction.date > Time.zone.today) && (transaction.balance >= 0)
      "text-muted"
    elsif transaction.balance.negative?
      "text-danger"
    end
  end
end
