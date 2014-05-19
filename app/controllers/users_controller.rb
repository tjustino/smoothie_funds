class UsersController < ApplicationController
  skip_before_action :authorize, :set_current_user, :set_current_accounts, only: [:new, :create]
  before_action :check_good_user_id, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_url, notice: t('.successfully_created') }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_url, notice: t('.successfully_updated') }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

    def check_good_user_id
      unless session[:user_id].to_i == params[:id].to_i
        redirect_to edit_user_url(session[:user_id])
      end
    end
end
