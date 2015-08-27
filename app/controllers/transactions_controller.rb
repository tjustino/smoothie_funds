class TransactionsController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/transactions
  def index
    load_limit

    if params[:offset]
      load_transactions( params[:offset].to_i.abs, @limit )
    else
      @limit = params[:limit].to_i * @limit unless params[:limit].blank?
      load_transactions( nil, @limit )
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
      redirect_to :back, notice: t('.successfully_destroyed')
    else
      flash[:warning] = t('.cant_destroy')
      redirect_to :back
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
        format.html { redirect_to :back, notice: t('.successfully_checked') }
        format.js   {}
      end
    end
  end


private ########################################################################

  def load_transactions(offset=nil, limit=nil)
    @initial_balance  =   @current_account.initial_balance
    @nb_transactions  =   current_transactions.count
    @sum_checked      =   @initial_balance + 
                          current_transactions.checked.sum(:amount)
    @transactions     ||= current_transactions.offset(offset)
                                              .limit(limit)
                                              .order_by_date_and_id
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
