module TransactionsHelper
  def decoration_according_to_(transaction)
    if (transaction.date > Time.zone.today) && (transaction.balance >= 0)
      "has-text-grey-light upcoming-transaction"
    elsif transaction.balance.negative?
      "has-text-danger upcoming-transaction"
    end
  end
end
