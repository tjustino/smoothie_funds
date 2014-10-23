class CategoriesController < ApplicationController
  before_action :set_current_account

  # GET /users/1/accounts/1/categories
  def index
    load_categories
  end

  # GET /users/1/accounts/1/categories/new
  def new
    build_category
  end

  # GET /users/1/accounts/1/categories/1/edit
  def edit
    load_category
    #build_category
  end

  # POST /users/1/accounts/1/categories
  def create
    build_category
    save_category( t('.successfully_created') ) or render 'new'
  end

  # PATCH/PUT /users/1/accounts/1/categories/1
  def update
    load_category
    build_category
    save_category( t('.successfully_updated') ) or render 'edit'
  end

  # DELETE /users/1/accounts/1/categories/1
  def destroy
    load_category
    if @category.destroy
      redirect_to user_account_categories_url, notice: t('.successfully_destroyed')
    else
      flash[:warning] = t('.cant_destroy')
      redirect_to user_account_categories_url
    end
  end


  private ######################################################################

    def load_categories
      #TODO remove kaminari
      @nb_categories = current_categories.count
      @categories ||= current_categories.order_by_name.page(params[:page]).per(20)
    end

    def load_category
      @category ||= current_categories.find(params[:id])
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
        redirect_to user_account_categories_url, notice: notice
      end
    end

    def current_categories
      @current_account.categories
    end
end
