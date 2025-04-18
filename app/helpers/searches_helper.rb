module SearchesHelper
  def joined_accounts_names(current_accounts, accounts)
    accounts_names = []
    current_accounts.where(id: accounts.map(&:to_i)).find_each { |account| accounts_names.push account.name }
    accounts_names.join(", ")
  end

  def joined_categories_names(current_accounts, accounts, categories)
    categories_names = []

    current_accounts.where(id: accounts.map(&:to_i)).find_each do |account|
      account.categories.order_by_name.where(id: categories.map(&:to_i)).find_each do |category|
        categories_names.push category.name
      end
    end

    categories_names.join(", ")
  end

  def witch_search(search, index)
    case index
    when 0 then t(".last_search")
    when 1 then t(".next_to_last_search")
    when 2 then t(".antepenultimate_search")
    else        t(".date_search", date: l(search.created_at.to_s))
    end
  end
end
