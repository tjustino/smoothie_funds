class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  # GET /passwords/new
  def new
  end

  # POST /passwords
  def create
    if user = User.find_by(email: params[:email])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to login_path, notice: t(".instructions_sent")
  end

  # GET /passwords/:token/edit
  def edit
  end

  # PATCH/PUT /passwords/:token
  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to login_path, notice: t(".password_reset")
    else
      redirect_to edit_password_path(params[:token]), alert: t(".passwords_mismatch")
    end
  end

  private ##############################################################################################################

    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: t(".invalid_link")
    end
end
