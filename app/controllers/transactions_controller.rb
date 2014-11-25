class TransactionsController < ApplicationController
  before_action :set_current_account

  # GET /users/1/accounts/1/transactions
  def index
    load_transactions
  end

  # GET /users/1/accounts/1/transactions/new
  def new
    build_transaction
    @sign = "debit"
  end

  # GET /users/1/accounts/1/transactions/1/edit
  def edit
    load_transaction
    #build_transaction

    @transaction.amount < 0 ? @sign = "debit" : @sign = "credit"
    @transaction.amount = @transaction.amount.abs
  end

  # POST /users/1/accounts/1/transactions
  def create
    build_transaction
    save_transaction( t('.successfully_created') ) or render 'new'
  end

  # PATCH/PUT /users/1/accounts/1/transactions/1
  def update
    load_transaction
    build_transaction
    save_transaction( t('.successfully_updated') ) or render 'edit'
  end

  # DELETE /users/1/accounts/1/transactions/1
  def destroy
    load_transaction
    if @transaction.destroy
      redirect_to user_account_transactions_url, notice: t('.successfully_destroyed')
    else
      flash[:warning] = t('.cant_destroy')
      redirect_to user_account_transactions_url
    end
  end

  # POST /users/1/accounts/1/transactions/1/easycheck
  def easycheck
    load_transaction
    @transaction.toggle :checked
    @transaction.updated_by = @current_user.id

    if @transaction.save
      # TODO if activerecord send an error, redirect_to :back is broken
      redirect_to :back, notice: t('.successfully_checked')
    end
  end


  private ######################################################################

    def load_transactions
      #TODO remove kaminari
      @nb_transactions = current_transactions.count
      transanstions_without_balances ||= current_transactions.active.order_by_date_and_id.to_a

      transanstions_without_balances.each_index do |index|
        if index == 0
          transanstions_without_balances[index].balance = 
                                    @current_account.initial_balance +
                                    transanstions_without_balances[index].amount
        else
          transanstions_without_balances[index].balance = 
                              transanstions_without_balances[index-1].balance +
                              transanstions_without_balances[index].amount
        end
      end

      @sum_checked = @current_account.initial_balance + current_transactions.checked.sum(:amount)

      @transactions = Kaminari.paginate_array(transanstions_without_balances.reverse!).page(params[:page]).per(20)
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
      transaction_params ? transaction_params.permit(:category_id, :date, :amount, :checked, :comment) : {}
    end

    def save_transaction(notice)
      if @transaction.save
        if params[:sign] == "credit"
          @transaction.amount = @transaction.amount.abs
        else
          @transaction.amount = -1 * @transaction.amount.abs
        end

        userstamp(@transaction)
        redirect_to user_account_transactions_url, notice: notice
      end
    end

    def current_transactions
      @current_account.transactions
    end
end
