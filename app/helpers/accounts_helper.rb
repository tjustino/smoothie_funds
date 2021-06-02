# frozen_string_literal: true

# Accounts Helper
module AccountsHelper
  def other_users(current_user, account)
    account.users.where.not(id: current_user)
  end

  def show_others_or_me(current_user, account)
    if account.users.count == 1
      t(".personal_account")
    else
      others = other_users(current_user, account)

      if others.count == 1
        email_or_name(others.take)
      else
        join_in(others)
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
    account.users.each do |other_user|
      array_of_users << email_or_name(other_user)
    end
    array_of_users.join(t(".and"))
  end

  private

    def join_in(others)
      array_of_users = []
      others.each { |other_user| array_of_users << email_or_name(other_user) }
      array_of_users.join(", ")
    end
end
