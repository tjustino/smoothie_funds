# SearchedTransactions for Searches and Transactions Controllers
module SearchedTransactions
  private

  def load_transactions(options = {})
    @transactions = Transaction.all
                               .active
                               .search_accounts(sanitize_accounts(@search.accounts))
                               .search_amount(@search.min, @search.max)
                               .search_date(@search.before, @search.after)
                               .search_categories(sanitize_categories(@search.categories))
                               .search_comment(@search.operator, @search.comment)
                               .search_checked(@search.checked)
                               .offset(options[:offset])
                               .limit(options[:limit])
                               .order_by_date_and_id_desc
  end

  def sanitize_accounts(accounts)
    @current_accounts.ids.intersection(accounts.ids)
  end

  def sanitize_categories(categories)
    Category.where(account_id: @current_accounts.ids).ids.intersection(categories.ids)
  end
end
