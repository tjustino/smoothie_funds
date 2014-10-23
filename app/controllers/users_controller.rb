class UsersController < ApplicationController
  skip_before_action :authorize, :set_current_user, :set_current_accounts, only: [:new, :create]

  # GET /users/new
  def new
    build_user
  end

  # GET /users/1/edit
  def edit
    load_user
    #build_user
  end

  # POST /users
  def create
    build_user
    save_created_user t('.successfully_created')
  end

  # PATCH/PUT /users/1
  def update
    load_user
    build_user
    save_updated_user t('.successfully_updated')
  end

  # DELETE /users/1
  def destroy
    #TODO how to delete an account?
  end


  private ######################################################################

    def load_user
      unless session[:user_id].to_i == params[:id].to_i
        redirect_to edit_user_url(session[:user_id])
      else
        @user ||= User.find(params[:id])
      end
    end

    def build_user
      @user ||= User.new
      @user.attributes = user_params
    end

    def user_params
      user_params = params[:user]
      user_params ? user_params.permit(:email, :name, :password, :password_confirmation) : {}
    end

    def save_created_user(notice)
      @user.save ? redirect_to(login_url, notice: notice) : render('new')
    end

    def save_updated_user(notice)
      @user.save ? redirect_to(edit_user_url, notice: notice) : render('edit')
    end
end
