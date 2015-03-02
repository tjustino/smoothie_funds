class CategoriesController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/categories
  def index
    load_categories
    load_other_accounts
  end

  # GET /accounts/:account_id/categories/new
  def new
    build_category
  end

  # GET /categories/:id/edit
  def edit
    load_category
    #build_category
  end

  # POST /accounts/:account_id/categories
  def create
    build_category
    save_category( t('.successfully_created') ) or render 'new'
  end

  # PATCH/PUT /categories/:id
  def update
    load_category
    build_category
    save_category( t('.successfully_updated') ) or render 'edit'
  end

  # DELETE /categories/:id
  def destroy
    load_category
    if @category.destroy
      redirect_to account_categories_url @current_account,
                  notice: t('.successfully_destroyed')
    else
      flash[:warning] = t('.cant_destroy')
      redirect_to account_categories_url @current_account
    end
  end

  # POST /accounts/:account_id/categories/import_from
  def import_from
    load_other_categories
    @other_categories.each do |other_category|
      unless current_categories.exists?(name: other_category.name)
        @category = current_categories.build
        @category.name = other_category.name
        save_category(nil)
      end
    end

    redirect_to account_categories_url(@current_account),
                notice: t('.successfully_imported')
  end


  private ######################################################################

    def load_categories
      #TODO remove kaminari
      @nb_categories = current_categories.count
      @categories ||= current_categories.order_by_name.page(params[:page]).per(20)
    end

    def load_other_accounts
      @other_accounts = @current_accounts.excluding(@current_account)
    end

    def load_category
      @category ||= current_categories.find(params[:id])
    end

    def load_other_categories
      @other_categories ||= @current_accounts.find(params[:account][:categories]).categories
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
      if @category.save
        userstamp(@category)
        redirect_to( account_categories_url(@current_account), notice: notice ) if notice
      end
    end

    def current_categories
      @current_account.categories
    end
end
