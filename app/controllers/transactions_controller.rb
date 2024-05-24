# frozen_string_literal: true

# Transactions Controller
class TransactionsController < ApplicationController
  include SearchedTransactions
  before_action :set_current_account

  # GET /accounts/:account_id/transactions
  def index
    load_limit

    respond_to do |format|
      format.html do
        @all_user_transactions = Transaction.active.where(account: @current_accounts)
        @nb_transactions = current_transactions.size
        @sum_checked     = @current_account.initial_balance + current_transactions.checked.sum(:amount)
        transactions(limit: @limit)
      end
      format.turbo_stream do
        @nb_transactions = current_transactions.size
        @nb_items = params[:offset].to_i.abs + @limit
        transactions(offset: params[:offset].to_i.abs, limit: @limit)
      end
      format.xlsx do
        attributes_to_extract = %w[id account_id category_id date amount checked comment]
        send_data current_transactions.to_xlsx(attributes_to_extract, "transactions"),
                  filename: "#{I18n.t("transactions.new.transactions")}_#{timestamp_for_export}.xlsx",
                  type:     :xlsx
      end
    end
  end

  # GET /accounts/:account_id/transactions/new
  def new
    build_transaction
    @sign = "debit"
  end

  # GET /transactions/:id/edit
  def edit
    transaction

    @sign = @transaction.amount.negative? ? "debit" : "credit"
    @transaction.amount = @transaction.amount.abs
    flash[:search_id] = params[:search_id] unless params[:search_id].nil?
  end

  # POST /accounts/:account_id/transactions
  def create
    build_transaction
    if save_transaction
      redirect_to account_transactions_url(@current_account), notice: t(".successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/:id
  def update
    # TODO: credit transaction + error screen = debit transaction
    transaction
    build_transaction
    if save_transaction
      if flash[:search_id].nil?
        redirect_to account_transactions_url(@current_account), notice: t(".successfully_updated"), status: :see_other
      else
        redirect_to search_url(flash[:search_id]), notice: t(".successfully_created")
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/:id
  def destroy
    transaction
    if params[:search_id].nil?
      # from transactions controller
      account = @transaction.account
      if @transaction.destroy
        respond_to do |format|
          format.html { redirect_to account_transactions_path(account), notice: t(".successfully_destroyed") }
          format.turbo_stream do
            @successful_destroy = true
            @nb_transactions = current_transactions.size
            flash.now[:notice] = t(".successfully_destroyed")
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to account_transactions_path(account), warning: t(".cant_destroy") }
          format.turbo_stream do
            @successful_destroy = false
            flash.now[:warning] = t(".cant_destroy")
          end
        end
      end
    else
      # from searches controller
      # TODO: definitely not the right paths
      if @transaction.destroy
        respond_to do |format|
          format.html { redirect_to search_path(@current_user), notice: t(".successfully_destroyed") }
          format.turbo_stream do
            @successful_destroy = true
            @search = @current_user.searches.find(params[:search_id])
            load_transactions
            @nb_transactions = @transactions.count
            @sum_transactions = @transactions.sum(:amount)
            flash.now[:notice] = t(".successfully_destroyed")
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to search_path(@current_user), warning: t(".cant_destroy") }
          format.turbo_stream do
            @successful_destroy = false
            flash.now[:warning] = t(".cant_destroy")
          end
        end
      end
    end
  end

  # POST /transactions/:id/easycheck
  def easycheck
    transaction
    account = @transaction.account
    @transaction.toggle :checked
    @transaction.updated_by = @current_user.id

    respond_to do |format|
      if @transaction.save
        @sum_checked = @current_account.initial_balance + current_transactions.checked.sum(:amount)
        format.html do
          redirect_to(account_transactions_path(account), notice: t(".successfully_checked"))
        end
        format.turbo_stream
      end
    end
  end

  private ##############################################################################################################

    def transactions(options = {})
      @transactions = current_transactions.with_balances_for(@current_account)
                                          .offset(options[:offset])
                                          .limit(options[:limit])
                                          .order_by_date_and_id_desc
    end

    def transaction
      @transaction ||= current_transactions.find(params[:id])
    end

    def build_transaction
      @transaction ||= current_transactions.build
      @transaction.attributes = transaction_params
    end

    def transaction_params
      transaction_params = params[:transaction]
      if transaction_params
        transaction_params.permit(:category_id, :date, :amount, :checked, :comment)
      else
        {}
      end
    end

    def save_transaction
      return unless @transaction.save

      @transaction.amount = params[:sign] == "credit" ? @transaction.amount.abs : (@transaction.amount.abs * -1)
      userstamp(@transaction)
    end

    def current_transactions
      @current_account.transactions.active
    end
end
