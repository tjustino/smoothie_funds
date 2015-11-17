module AccountsHelper
  def other_users(account)
    account.users.where.not(id: @current_user)
  end

  def show_others_or_me(account)
    if account.users.count == 1
      return t('.personal_account')
    else
      others = other_users(account)

      if others.count == 1
        email_or_name(others.take)
      else
        array_of_users = []
        others.each { |other_user| array_of_users << email_or_name(other_user) }
        array_of_users.join(", ")
      end
    end
  end

  def email_or_name(user)
    if user.name.blank?
      mail_to user.email
    else
      mail_to user.email, user.name
    end 
  end

  def show_other_users(account)
    array_of_users = []
    account.users.each { |other_user| array_of_users << email_or_name(other_user) }
    array_of_users.join( t('.and') )
  end
end