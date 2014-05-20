class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]
  before_action :set_current_account

  # GET /users/1/accounts/1/categories
  def index
    @categories = @current_account.categories.order(:name).page(params[:page]).per(20)
  end

  # GET /users/1/accounts/1/categories/new
  def new
    @category = Category.new
  end

  # GET /users/1/accounts/1/categories/1/edit
  def edit
  end

  # POST /users/1/accounts/1/categories
  def create
    @category = Category.new(category_params)
    @category.account     = @current_account
    @category.created_by  = @current_user.id
    @category.updated_by  = @current_user.id

    respond_to do |format|
      if @category.save
        format.html { redirect_to user_account_categories_url, notice: t('.successfully_created') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1/accounts/1/categories/1
  def update
    @category.updated_by = @current_user.id

    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to user_account_categories_url, notice: t('.successfully_updated') }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1/accounts/1/categories/1
  def destroy
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to user_account_categories_url, notice: t('.successfully_destroyed') }
      else
        flash[:warning] = t('.cant_destroy')
        format.html { redirect_to user_account_categories_url  }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end
end
