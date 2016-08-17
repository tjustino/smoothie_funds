class TransactionsController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/transactions
  def index
    load_limit

    if params[:offset]
      load_transactions( params[:offset].to_i.abs, @limit )
    else
      load_transactions( 0, @limit )
      @all_user_transactions = Transaction.where(account: @current_accounts)
    end
  end

  # GET /accounts/:account_id/transactions/new
  def new
    build_transaction
    @sign = "debit"
  end

  # GET /transactions/:id/edit
  def edit
    load_transaction
    #build_transaction

    @transaction.amount < 0 ? @sign = "debit" : @sign = "credit"
    @transaction.amount = @transaction.amount.abs
    flash[:search_id] = params[:search_id] unless params[:search_id].nil? 
  end

  # POST /accounts/:account_id/transactions
  def create
    build_transaction
    save_transaction( t('.successfully_created') ) or render 'new'
  end

  # PATCH/PUT /transactions/:id
  def update
    #TODO trans en crédit + écran d'erreur = trans en débit
    load_transaction
    build_transaction
    save_transaction( t('.successfully_updated') ) or render 'edit'
  end

  # DELETE /transactions/:id
  def destroy
    load_transaction
    if @transaction.destroy
      # redirect_to :back, notice: t('.successfully_destroyed')
      case controller_name
        when "transactions"
          redirect_back fallback_location: account_transactions_path(@current_account),
                        notice: t('.successfully_destroyed')
        when "searches"
          redirect_back fallback_location: new_user_search_path(@current_user),
                        notice: t('.successfully_destroyed')
      end
    else
      flash[:warning] = t('.cant_destroy')
      case controller_name
        when "transactions"
          redirect_back fallback_location: account_transactions_path(@current_account)
        when "searches"
          redirect_back fallback_location: new_user_search_path(@current_user)
      end
    end
  end

  # POST /transactions/:id/easycheck
  def easycheck
    load_transaction
    @transaction.toggle :checked
    @transaction.updated_by = @current_user.id

    respond_to do |format|
      if @transaction.save
        @sum_checked =  @current_account.initial_balance +
                        current_transactions.checked.sum(:amount)
        # TODO if activerecord send an error, redirect_to :back is broken
        format.html { case controller_name
                        when "transactions"
                          redirect_back fallback_location: account_transactions_path(@current_account), notice: t('.successfully_checked')
                        when "searches"
                          redirect_back fallback_location: new_user_search_path(@current_user), notice: t('.successfully_checked')
                      end }
        format.js   {}
      end
    end
  end


private ########################################################################

  def load_transactions(offset=0, limit=nil)
    my_transactions   = current_transactions.order_by_date_and_id_desc
    @nb_transactions  = my_transactions.count

    if offset == 0
      @initial_balance = @current_account.initial_balance
      @sum_checked     = @initial_balance + my_transactions.checked.sum(:amount)
    end

    @transactions = add_balances(my_transactions).to_a[offset, limit]
  end

  def add_balances(transactions)
    transactions.reverse.each_with_index do |transaction, index|
      if index == 0
        transaction.balance = @current_account.initial_balance + transaction.amount
      else
        transaction.balance = transactions.reverse[index-1].balance + transaction.amount
      end
    end

    return transactions
  end

  def load_transaction
    @transaction ||= current_transactions.find(params[:id])
  end

  def build_transaction
    @transaction ||= current_transactions.build
    @transaction.attributes = transaction_params
  end

  def transaction_params
    transaction_params = params[:transaction]
    transaction_params ? transaction_params.permit( :category_id,
                                                    :date,
                                                    :amount,
                                                    :checked,
                                                    :comment ) : {}
  end

  def save_transaction(notice)
    if @transaction.save
      if params[:sign] == "credit"
        @transaction.amount = @transaction.amount.abs
      else
        @transaction.amount = -1 * @transaction.amount.abs
      end

      userstamp(@transaction)

      if flash[:search_id].nil?
        redirect_to account_transactions_url(@current_account), notice: notice
      else
        redirect_to search_url(flash[:search_id]), notice: notice
      end
    end
  end

  def current_transactions
    @current_account.transactions.active
  end
end
