# frozen_string_literal: true

# Transactions Helper
module TransactionsHelper
  def decoration_according_to_(transaction)
    if (transaction.date > Date.today) && (transaction.balance < 0)
      "text-danger"
    elsif (transaction.date > Date.today) && (transaction.balance >= 0)
      "text-muted"
    end
  end
end