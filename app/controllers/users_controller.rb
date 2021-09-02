# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  skip_before_action :set_current_user, :set_current_accounts, :set_accounts_with_categories, only: %i[new create]

  # GET /users/new
  def new
    # authorize don't make the job
    if session[:user_id].present?
      redirect_to dashboard_url
    else
      build_user
    end
  end

  # GET /users/:id/edit
  def edit
    user
    count_deletion_impact
  end

  # POST /users
  def create
    build_user
    save_created_user t(".successfully_created")
  end

  # PATCH/PUT /users/:id
  def update
    user
    build_user
    save_updated_user t(".successfully_updated")
  end

  # DELETE /users/:id
  def destroy
    user
    if delete_all_data && @current_user.destroy
      session[:user_id] = nil
      redirect_to login_url, notice: t(".successfully_destroyed")
    else
      flash[:warning] = t(".cant_destroy")
      redirect_to accounts_url
    end
  end

  private ######################################################################

    def user
      @user ||= @current_user
    end

    def build_user
      @user ||= User.new
      @user.attributes = user_params
    end

    def user_params
      user_params = params[:user]
      if user_params
        user_params.permit(:email, :name, :password, :password_confirmation)
      else
        {}
      end
    end

    def save_created_user(notice)
      @user.save ? redirect_to(login_url, notice: notice) : render("new")
    end

    def save_updated_user(notice)
      @user.save ? redirect_to(edit_user_url, notice: notice) : render("edit")
    end

    def count_deletion_impact
      set_targeted_accounts
      @nof_accounts     = @targeted_accounts.length
      @nof_categories   = Category.where(account_id: @targeted_accounts).count
      @nof_schedules    = Schedule.where(account_id: @targeted_accounts).count
      @nof_searches     = @user.searches.count
      @nof_transactions = Transaction.active.where(account_id: @targeted_accounts).count
    end

    def set_targeted_accounts
      @targeted_accounts = Relation.not_shared_accounts(@current_user.accounts)
    end

    def delete_all_data
      set_targeted_accounts
      # consider erasing (following this order):
      #   - searches
      #   - schedules
      #   - transactions
      #   - categories
      #   - pending_users
      #   - relations
      #   - accounts
      #   - user
      @user.searches.delete_all
      Schedule.where(account_id: @targeted_accounts).delete_all
      Transaction.active.where(account_id: @targeted_accounts).delete_all
      Category.where(account_id: @targeted_accounts).delete_all
      PendingUser.where(account_id: @targeted_accounts).delete_all
      Relation.where(account_id: @targeted_accounts).delete_all
      Account.where(id: @targeted_accounts).delete_all
    end
end
