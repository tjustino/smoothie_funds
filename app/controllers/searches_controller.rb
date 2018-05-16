# frozen_string_literal: true

# Searches Controller
class SearchesController < ApplicationController
  # GET /searches/:id
  def show
    load_limit
    search

    if params[:offset]
      load_transactions(params[:offset].to_i.abs, @limit)
    else
      load_transactions
      @nb_transactions  = @transactions.count
      @sum_transactions = @transactions.sum(:amount)
      @transactions     = @transactions.limit(@limit)
    end
  end

  # GET /users/:user_id/searches/new
  def new
    searches
    build_search
  end

  # POST /users/:user_id/searches
  def create
    build_search
    save_search || render("new")
  end

  # DELETE /searches/:id
  def destroy
    search
    if @search.destroy
      redirect_to new_user_search_url(@current_user),
                  notice: t(".successfully_destroyed")
    else
      flash[:warning] = t(".cant_destroy")
      redirect_to new_user_search_url(@current_user)
    end
  end

  private ######################################################################

    def searches
      @searches ||= current_searches.order(id: :desc)
    end

    def search
      @search ||= current_searches.find(params[:id])
    end

    def build_search
      @search ||= current_searches.build
      @search.attributes = search_params
    end

    def search_params
      search_params = params[:search]
      if search_params
        search_params.permit({ accounts: [] }, :min, :max, :before, :after,
                             { categories: [] }, :operator, :comment, :checked)
      else
        {}
      end
    end

    def save_search
      return unless @search.save

      current_searches.order(id: :desc).offset(3).destroy_all
      redirect_to(@search)
    end

    def current_searches
      @current_user.searches
    end

    def load_transactions(offset = nil, limit = nil)
      @transactions = Transaction.all
                                 .active
                                 .search_accounts(
                                   sanitize_accounts(@search.accounts))
                                 .search_amount(@search.min, @search.max)
                                 .search_date(@search.before, @search.after)
                                 .search_categories(
                                   sanitize_categories(@search.categories))
                                 .search_comment(@search.operator,
                                                 @search.comment)
                                 .search_checked(@search.checked)
                                 .offset(offset)
                                 .limit(limit)
                                 .order_by_date_and_id_desc
    end

    def sanitize_accounts(accounts)
      # accounts = accounts.map { |account| account.to_i }
      accounts = accounts.map(&:to_i)
      @current_accounts.ids & accounts
    end

    def sanitize_categories(categories)
      # categories = categories.map { |category| category.to_i }
      categories = categories.map(&:to_i)
      Category.where(account_id: @current_accounts.ids).ids & categories
    end
end
