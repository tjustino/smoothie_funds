# frozen_string_literal: true

# Categories Controller
class CategoriesController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/categories
  def index
    load_limit

    if params[:offset]
      categories(params[:offset].to_i.abs, @limit)
    else
      categories(nil, @limit)
      load_other_accounts
      @all_user_categories = Category.where(account: @current_accounts)
    end

    respond_to do |format|
      format.html
      format.js.coffee
      format.csv do
        attributes_to_extract = %w[id account_id name]
        send_data current_categories.to_csv(attributes_to_extract),
                  filename: "categories_#{timestamp_for_export}.csv",
                  type:     "text/csv"
      end
    end
  end

  # GET /accounts/:account_id/categories/new
  def new
    build_category
  end

  # GET /categories/:id/edit
  def edit
    category
  end

  # POST /accounts/:account_id/categories
  def create
    build_category
    save_category(t(".successfully_created")) || render("new")
  end

  # PATCH/PUT /categories/:id
  def update
    category
    build_category
    save_category(t(".successfully_updated")) || render("edit")
  end

  # DELETE /categories/:id
  def destroy
    category
    if @category.destroy
      redirect_to account_categories_url(@current_account),
                  notice: t(".successfully_destroyed")
    else
      flash[:warning] = t(".cant_destroy")
      redirect_to account_categories_url(@current_account)
    end
  end

  # POST /accounts/:account_id/categories/import_from
  def import_from
    other_categories
    @other_categories.each do |other_category|
      next if current_categories.exists?(name: other_category.name)
      @category = current_categories.build
      @category.name = other_category.name
      save_category(nil)
    end

    redirect_to account_categories_url(@current_account),
                notice: t(".successfully_imported")
  end

  private ######################################################################

    def categories(offset = nil, limit = nil)
      @nb_categories = current_categories.count
      @categories ||= current_categories.offset(offset)
                                        .limit(limit)
                                        .order_by_name
    end

    def load_other_accounts
      @other_accounts = @current_accounts.excluding(@current_account)
    end

    def category
      @category ||= current_categories.find(params[:id])
    end

    def other_categories
      @other_categories ||=
        @current_accounts.find(params[:account][:categories]).categories
    end

    def build_category
      @category ||= current_categories.build
      @category.attributes = category_params
    end

    def category_params
      category_params = params[:category]
      category_params ? category_params.permit(:name) : {}
    end

    def save_category(notice)
      return unless @category.save
      userstamp(@category)
      return unless notice
      redirect_to(account_categories_url(@current_account), notice: notice)
    end

    def current_categories
      @current_account.categories
    end
end
