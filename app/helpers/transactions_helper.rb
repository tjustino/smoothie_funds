module TransactionsHelper
  def is_upcomming?(transaction)
    "class=upcoming-transaction" if (transaction.date > Time.zone.today)
  end

  def decoration_according_to_(transaction)
    if (transaction.date > Time.zone.today) && (transaction.balance >= 0)
      "has-text-grey"
    elsif transaction.balance.negative?
      "has-text-danger"
    end
  end
end
