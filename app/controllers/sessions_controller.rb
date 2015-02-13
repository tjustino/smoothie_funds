class SessionsController < ApplicationController
  skip_before_action :set_current_user, :set_current_accounts

  # GET /sessions/new
  def new
    # authorize don't make the job
    unless session[:user_id].blank?
      redirect_to dashboard_url
    end
  end

  # POST /sessions
  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_url
    else
      redirect_to login_url, alert: t('.invalid_combination')
    end
  end

  # DELETE /sessions/1
  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: t('.logged_out')
  end
end
