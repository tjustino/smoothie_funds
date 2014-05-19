class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :destroy]

  # GET /users/1/accounts
  def index
    @accounts = @current_user.accounts.order(:name)
  end

  # GET /users/1/accounts/new
  def new
    @account = Account.new
  end

  # GET /users/1/accounts/1/edit
  def edit
    @current_user
  end

  # POST /users/1/accounts
  def create
    @account = Account.new(account_params)
    @account.created_by = @current_user.id
    @account.updated_by = @current_user.id

    respond_to do |format|
      if @account.save
        @account.users << @current_user
        format.html { redirect_to user_accounts_url, notice: t('.successfully_created') }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /users/1/accounts/1
  def update
    @account.updated_by = @current_user.id

    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to user_accounts_url, notice: t('.successfully_updated') }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /users/1/accounts/1
  def destroy
    respond_to do |format|
      if @account.destroy
        format.html { redirect_to user_accounts_url, notice: t('.successfully_destroyed') }
      else
        flash[:warning] = t('.cant_destroy')
        format.html { redirect_to user_accounts_url  }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :initial_balance)
    end
end
