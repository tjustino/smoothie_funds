require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "reset password email" do
    user  = users(:thomas)
    email = PasswordsMailer.reset(user)

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "noreply@smoothiefunds.com" ], email.from
    assert_equal [ user.email ], email.to
    assert_equal I18n.t("passwords_mailer.reset.reset_password"), email.subject
  end
end
