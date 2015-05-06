class AccountsController < ApplicationController

  # GET /accounts
  def index
    load_accounts
  end

  # GET /accounts/new
  def new
    build_account
  end

  # GET /accounts/:id/edit
  def edit
    # TODO: can't edit an account if hidden
    load_account
    #build_account
  end

  # POST /accounts
  def create
    build_account
    save_account( t('.successfully_created') ) or render 'new'
  end

  # PATCH/PUT /accounts/:id
  def update
    load_account
    build_account
    save_account( t('.successfully_updated') ) or render 'edit'
  end

  # DELETE /accounts/:id
  def destroy
    load_account
    if @account.destroy
      redirect_to accounts_url, notice: t('.successfully_destroyed')
    else
      flash[:warning] = t('.cant_destroy')
      redirect_to accounts_url
    end
  end


  private ######################################################################

    def load_accounts
      @accounts ||= current_accounts.order_by_name
    end

    def load_account
      @account ||= current_accounts.find(params[:id])
    end

    def build_account
      @account ||= current_accounts.build
      @account.attributes = account_params
    end

    def account_params
      account_params = params[:account]
      account_params ? account_params.permit(:name, :initial_balance, :hidden) : {}
    end

    def save_account(notice)
      if @account.save
        @account.users << @current_user if params[:action] == "create"
        userstamp(@account)
        redirect_to accounts_url, notice: notice
      end
    end

    def current_accounts
      @current_user.accounts
    end
end
