class UsersController < ApplicationController
  skip_before_action :set_current_user, :set_current_accounts, only: [:new, :create]

  # GET /users/new
  def new
    # authorize don't make the job
    unless session[:user_id].blank?
      redirect_to dashboard_url
    else
      build_user
    end
  end

  # GET /users/:id/edit
  def edit
    load_user
    #build_user
  end

  # POST /users
  def create
    build_user
    save_created_user t('.successfully_created')
  end

  # PATCH/PUT /users/:id
  def update
    load_user
    build_user
    save_updated_user t('.successfully_updated')
  end

  #TODO how to delete an account?
  # DELETE /users/:id
  # def destroy
  # end


  private ######################################################################

    def load_user
      @user ||= @current_user
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
