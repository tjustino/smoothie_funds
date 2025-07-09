class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 5, within: 3.minutes, only: :create, with: -> { redirect_to login_url, alert: t(".try_later") }

  # GET /login
  def new
    redirect_to dashboard_url if authenticated?
  end

  # POST /login
  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      start_new_session_for user
      Current.session.user = user
      redirect_to requested_url
    else
      redirect_to login_url, alert: t(".invalid_combination")
    end
  end

  # DELETE /logout
  def destroy
    terminate_session
    redirect_to login_url, notice: t(".logged_out")
  end
end
