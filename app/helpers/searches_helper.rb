module SearchesHelper
  def witch_search(search, index)
    case index
    when 0 then t(".last_search")
    when 1 then t(".next_to_last_search")
    when 2 then t(".antepenultimate_search")
    else        t(".date_search", date: l(search.created_at.to_s))
    end
  end
end
