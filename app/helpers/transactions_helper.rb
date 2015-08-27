module TransactionsHelper
  def add_balances(transactions)
    transanstions_without_balances ||= transactions.to_a

    transanstions_without_balances.each_index do |index|
      if index == 0
        transanstions_without_balances[index].balance = 
                                  @current_account.initial_balance +
                                  transanstions_without_balances[index].amount
      else
        transanstions_without_balances[index].balance = 
                            transanstions_without_balances[index-1].balance +
                            transanstions_without_balances[index].amount
      end
    end

    return transanstions_without_balances.reverse!
  end
end