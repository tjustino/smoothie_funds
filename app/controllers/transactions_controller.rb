# frozen_string_literal: true

# Transactions Controller
class TransactionsController < ApplicationController
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
      format.js { transactions(offset: params[:offset].to_i.abs, limit: @limit) }
      format.csv do
        attributes_to_extract = %w[id account_id category_id date amount checked comment]
        send_data current_transactions.to_csv(attributes_to_extract),
                  filename: "transactions_#{timestamp_for_export}.csv",
                  type:     "text/csv"
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
    save_transaction(t(".successfully_created")) || render("new")
  end

  # PATCH/PUT /transactions/:id
  def update
    # TODO: credit transaction + error screen = debit transaction
    transaction
    build_transaction
    save_transaction(t(".successfully_updated")) || render("edit")
  end

  # DELETE /transactions/:id
  def destroy
    transaction
    if @transaction.destroy
      # redirect_to :back, notice: t(".successfully_destroyed")
      case controller_name
      when "transactions"
        redirect_back(
          fallback_location: account_transactions_path(@current_account),
          notice:            t(".successfully_destroyed")
        )
      when "searches"
        redirect_back fallback_location: new_user_search_path(@current_user),
                      notice:            t(".successfully_destroyed")
      end
    else
      flash[:warning] = t(".cant_destroy")
      case controller_name
      when "transactions"
        redirect_back(
          fallback_location: account_transactions_path(@current_account)
        )
      when "searches"
        redirect_back fallback_location: new_user_search_path(@current_user)
      end
    end
  end

  # POST /transactions/:id/easycheck
  def easycheck
    transaction
    @transaction.toggle :checked
    @transaction.updated_by = @current_user.id

    respond_to do |format|
      if @transaction.save
        @sum_checked = @current_account.initial_balance + current_transactions.checked.sum(:amount)
        # TODO: if activerecord send an error, redirect_to :back is broken
        format.html do
          case controller_name
          when "transactions"
            redirect_back(
              fallback_location: account_transactions_path(@current_account),
              notice:            t(".successfully_checked")
            )
          when "searches"
            redirect_back(
              fallback_location: new_user_search_path(@current_user),
              notice:            t(".successfully_checked")
            )
          end
        end
        format.js
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

    def save_transaction(notice)
      return unless @transaction.save

      @transaction.amount = params[:sign] == "credit" ? @transaction.amount.abs : (@transaction.amount.abs * -1)
      userstamp(@transaction)

      if flash[:search_id].nil?
        redirect_to account_transactions_url(@current_account), notice: notice
      else
        redirect_to search_url(flash[:search_id]), notice: notice
      end
    end

    def current_transactions
      @current_account.transactions.active
    end
end
