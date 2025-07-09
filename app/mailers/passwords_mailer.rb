class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail to: user.email, subject: t(".reset_password")
  end
end
