require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  ################################################################################################### GET /passwords/new
  test "as a not logged user, I should be get new password path" do
    get "/passwords/new"

    assert_response :success
  end

  test "as a logged user, I should be redirected to dashboard path" do
    login_as :thomas
    get "/passwords/new"

    assert_redirected_to dashboard_path
  end

  ###################################################################################################### POST /passwords
  test "as a not logged user, I should should have received an email and be redirected to login path" do
    user = users(:thomas)
    post passwords_path, params: { email: user.email }

    assert_enqueued_email_with PasswordsMailer, :reset, args: user
    assert_redirected_to       login_path
    assert_equal               I18n.t("passwords.create.instructions_sent"), flash[:notice]
  end

  test "as a unknown email, I should should not have received an email and should be redirected to login path" do
    post passwords_path, params: { email: "unknown_email@domain.tld" }

    assert_no_enqueued_emails
    assert_redirected_to login_path
    assert_equal         I18n.t("passwords.create.instructions_sent"), flash[:notice]
  end

  test "as a logged user, I should be redirected to dashboard path and and no email should have been sent" do
    login_as :thomas
    user = users(:thomas)
    post passwords_path, params: { email: user.email }

    assert_no_enqueued_emails
    assert_redirected_to dashboard_path
  end

  ########################################################################################### GET /passwords/:token/edit
  test "as a not logged user with a correct token, I should get edit password path" do
    token = users(:thomas).password_reset_token
    get "/passwords/#{token}/edit"

    assert_response :success
  end

  test "as a not logged user with an incorrect token, I should be redirected to new password path" do
    get "/passwords/my-questionable-token/edit"

    assert_redirected_to new_password_path
    assert_equal         I18n.t("passwords.invalid_link"), flash[:alert]
  end

  test "as a logged user with any token, I should be redirected the dashboard path" do
    login_as :thomas

    token = users(:thomas).password_reset_token
    get "/passwords/#{token}/edit"
    assert_redirected_to dashboard_path

    get "/passwords/my-questionable-token/edit"
    assert_redirected_to dashboard_path
  end

  ########################################################################################## PATCH/PUT /passwords/:token
  test "as a not logged user with a correct token and a correct entries, I should update my password" do
    user         = users(:thomas)
    token        = user.password_reset_token
    old_password = user.password_digest

    update_password(token, "MyP@ssw0rd!", "MyP@ssw0rd!")

    assert_not_equal     old_password, user.reload.password_digest
    assert_redirected_to login_path
    assert_equal         I18n.t("passwords.update.password_reset"), flash[:notice]
  end

  test "as a not logged user with a correct token and incorrect entries, I should not update my password" do
    user         = users(:thomas)
    token        = user.password_reset_token
    old_password = user.password_digest

    update_password(token, "MyP@ssw0rd!", "NotTheS@meP@ssw0rd!")

    assert_equal         old_password, user.reload.password_digest
    assert_redirected_to edit_password_path(token)
    assert_equal         I18n.t("passwords.update.passwords_mismatch"), flash[:alert]
  end

  test "as a not logged user with an incorrect token and entries, I should be redirected to" do
    patch "/passwords/my-questionable-token", params: { password: "MyP@ssw0rd!", password_confirmation: "MyP@ssw0rd!" }

    assert_redirected_to new_password_path
    assert_equal         I18n.t("passwords.invalid_link"), flash[:alert]
  end

  test "as a logged user with token and entries, I should be redirected to dashboard url" do
    login_as :thomas

    user         = users(:thomas)
    token        = user.password_reset_token
    old_password = user.password_digest

    update_password(token, "MyP@ssw0rd!", "MyP@ssw0rd!")

    assert_equal         old_password, user.reload.password_digest
    assert_redirected_to dashboard_url
  end

  private ##############################################################################################################

    def update_password(token, password, password_confirmation)
      patch "/passwords/#{token}", params: { password: password, password_confirmation: password_confirmation }
    end
end
