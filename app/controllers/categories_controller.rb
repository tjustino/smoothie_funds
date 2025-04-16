class CategoriesController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/categories
  def index
    load_limit

    respond_to do |format|
      format.html do
        @nb_categories = current_categories.count
        categories(limit: @limit)
        load_other_accounts
        @all_user_categories = Category.where(account: @current_accounts)
      end
      format.turbo_stream do
        @nb_categories = current_categories.count
        @nb_items = params[:offset].to_i.abs + @limit
        categories(offset: params[:offset].to_i.abs, limit: @limit)
      end
      format.xlsx do
        attributes_to_extract = %w[id account_id name hidden]
        send_data current_categories.to_xlsx(attributes_to_extract, "categories"),
                  filename: "#{I18n.t("categories.new.categories")}_#{timestamp_for_export}.xlsx",
                  type:     :xlsx
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
    if save_category
      redirect_to account_categories_url(@current_account), notice: t(".successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/:id
  def update
    category
    build_category
    if save_category
      redirect_to account_categories_url(@current_account), notice: t(".successfully_updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:id
  def destroy
    category
    if @category.destroy
      respond_to do |format|
        format.html { redirect_to account_categories_url(@current_account), notice: t(".successfully_destroyed") }
        format.turbo_stream do
          @successful_destroy = true
          @nb_categories = current_categories.count
          flash.now[:notice] = t(".successfully_destroyed")
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to account_categories_url(@current_account), warning: t(".cant_destroy") }
        format.turbo_stream do
          @successful_destroy = false
          flash.now[:warning] = t(".cant_destroy")
        end
      end
    end
  end

  # POST /accounts/:account_id/categories/import_from
  def import_from
    other_categories
    @other_categories.each do |other_category|
      next if current_categories.exists?(name: other_category.name)

      @category = current_categories.build
      @category.name   = other_category.name
      @category.hidden = other_category.hidden
      save_category
    end

    redirect_to account_categories_url(@current_account), notice: t(".successfully_imported")
  end

  private ##############################################################################################################

    def categories(options = {})
      @categories ||= current_categories.offset(options[:offset]).limit(options[:limit]).order_by_name
    end

    def load_other_accounts
      @other_accounts = @current_accounts.free_of(@current_account)
    end

    def category
      @category ||= current_categories.find(params[:id])
    end

    def other_categories
      @other_categories ||= @current_accounts.find(params[:categories]).categories
    end

    def build_category
      @category ||= current_categories.build
      @category.attributes = category_params
    end

    def category_params
      category_params = params[:category]
      category_params ? category_params.permit(:name, :hidden) : {}
    end

    def save_category
      return unless @category.save

      userstamp(@category)
    end

    def current_categories
      @current_account.categories
    end
end
