# frozen_string_literal: true

# Accounts Controller
class AccountsController < ApplicationController
  # GET /accounts
  def index
    load_limit

    respond_to do |format|
      format.html do
        @nb_accounts = current_accounts.count
        accounts(limit: @limit)
        load_pendings
      end
      format.turbo_stream do
        @nb_accounts = current_accounts.count
        @nb_items = params[:offset].to_i.abs + @limit
        accounts(offset: params[:offset].to_i.abs, limit: @limit)
      end
      format.xlsx do
        attributes_to_extract = %w[id name initial_balance hidden]

        send_data current_accounts.to_xlsx(attributes_to_extract, "accounts"),
                  filename: "#{I18n.t("accounts.new.accounts")}_#{timestamp_for_export}.xlsx",
                  type:     :xlsx
      end
    end
  end

  # GET /accounts/new
  def new
    build_account
  end

  # GET /accounts/:id/edit
  def edit
    account
  end

  # POST /accounts
  def create
    build_account
    if save_account
      redirect_to accounts_url, notice: t(".successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/:id
  def update
    account
    build_account
    if save_account
      redirect_to accounts_url, notice: t(".successfully_updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/:id
  def destroy
    account
    if @account.destroy
      respond_to do |format|
        format.html { redirect_to accounts_url, notice: t(".successfully_destroyed") }
        format.turbo_stream do
          @successful_destroy = true
          @nb_accounts = current_accounts.count
          flash.now[:notice] = t(".successfully_destroyed")
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to accounts_url, warning: t(".cant_destroy") }
        format.turbo_stream do
          @successful_destroy = false
          flash.now[:warning] = t(".cant_destroy")
        end
      end
    end
  end

  # DELETE /accounts/:id/unlink
  def unlink
    account
    if @account.users.count > 1 && @account.users.destroy(@current_user)
      redirect_to accounts_url, notice: t(".successfully_unlinked")
    else
      flash[:warning] = t(".cant_unlink")
      redirect_to accounts_url
    end
  end

  # DELETE /accounts/:id/unpend
  def unpend
    account
    if @account.pending_user.destroy
      # sending email
      redirect_to accounts_url, notice: t(".successfully_unpend", account: @account.name)
    else
      flash[:warning] = t(".cant_unpend", account: @account.name)
      redirect_to accounts_url
    end
  end

  # POST /accounts/:id/sharing
  def sharing
    share_or_not true, ".successfully_sharing", ".cant_sharing"
  end

  # DELETE /accounts/:id/unsharing
  def unsharing
    share_or_not false, ".successfully_unsharing", ".cant_unsharing"
  end

  private ##############################################################################################################

    def accounts(options = {})
      @accounts ||= current_accounts.offset(options[:offset]).limit(options[:limit]).order_by_name
    end

    def account
      @account ||= current_accounts.find(params[:id])
    end

    def build_account
      @account ||= current_accounts.build
      @account.attributes = account_params
    end

    def account_params
      account_params = params[:account]
      if account_params
        account_params.permit(:name,
                              :initial_balance,
                              :hidden,
                              pending_user_attributes: [ :email ])
      else
        {}
      end
    end

    def save_account
      return unless @account.save

      if params[:new_share]
        PendingUser.create(account_id: @account.id, email: params[:new_share])
        # sending email
      end
      @account.users << @current_user if params[:action] == "create"
      userstamp(@account)
    end

    def current_accounts
      @current_user.accounts
    end

    def load_pendings
      @pendings = PendingUser.where(email: @current_user.email)
    end

    def share_or_not(sharing, notice, warning)
      @account = Account.find_by(id: params[:id])
      if @account.present?
        pending = PendingUser.where(email: @current_user.email, account: @account)
        if pending.any?
          pending.destroy_all
          @account.users << @current_user if sharing
          # sending email
          redirect_to accounts_url, notice: t(notice, account: @account.name)
        else
          flash[:warning] = t(warning, account: @account.name)
          redirect_to accounts_url
        end
      else
        redirect_to dashboard_url
      end
    end
end
