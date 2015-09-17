module AccountsHelper
  def other_users(account)
    account.users.where.not(id: @current_user)
  end

  def show_other_users(account)
    others = other_users(account)

    if others.count == 1
      email_or_name(others.take)
    else
      array_of_users = []
      others.each { |other_user| array_of_users << email_or_name(other_user) }
      array_of_users.join(", ")
    end
  end

  def email_or_name(other_user)
    if other_user.name.blank?
      mail_to other_user.email
    else
      mail_to other_user.email, other_user.name
    end 
  end
end