class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_current_account

  # GET /users/1/accounts/1/transactions
  def index
    twb = @current_account.transactions.order(date: :asc).to_a

    twb.each_index do |index|
      if index == 0
        twb[index].balance = @current_account.initial_balance + twb[index].amount
      else
        twb[index].balance = twb[index-1].balance + twb[index].amount
      end
    end

    @sum_checked = @current_account.transactions.where(checked: true).sum(:amount)
    @transactions = twb.reverse!
  end

  # GET /users/1/accounts/1/transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /users/1/accounts/1/transactions/1/edit
  def edit
  end

  # POST /users/1/accounts/1/transactions
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.account     = @current_account
    @transaction.created_by  = @current_user.id
    @transaction.updated_by  = @current_user.id

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to user_account_transactions_url, notice: t('.successfully_created') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1/accounts/1/transactions/1
  def update
    @transaction.updated_by = @current_user.id

    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to user_account_transactions_url, notice: t('.successfully_updated') }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1/accounts/1/transactions/1
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to user_account_transactions_url, notice: t('.successfully_destroyed') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:category_id, :date, :amount, :checked, :comment)
    end
end
