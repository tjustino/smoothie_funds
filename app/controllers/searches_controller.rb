class SearchesController < ApplicationController
  include SearchedTransactions

  # GET /searches/:id
  def show
    search
    load_limit
    load_transactions

    respond_to do |format|
      format.html do
        @nb_transactions  = @transactions.count
        @sum_transactions = @transactions.sum(:amount)
        @transactions     = @transactions.limit(@limit)
      end
      format.turbo_stream do
        @nb_transactions  = @transactions.count
        @nb_items = params[:offset].to_i.abs + @limit
        load_transactions(offset: params[:offset].to_i.abs, limit: @limit)
      end
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
      redirect_to new_user_search_url(@current_user), notice: t(".successfully_destroyed")
    else
      flash[:warning] = t(".cant_destroy")
      redirect_to new_user_search_url(@current_user)
    end
  end

  private ##############################################################################################################

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
        # search_params.permit(:min, :max, :before, :after, :operator, :comment, :checked)
        search_params.permit(
          :min, :max, :before, :after, :operator, :comment, :checked,
          search_targets_attributes: [ :id, :target_type, :target_id, :_destroy ]
        )

        # search_targets_attributes = []
        #
        # params[:search][:accounts].each do |account_id|
        #   search_targets_attributes << { target_type: "Account", target_id: account_id }
        # end
        #
        # params[:search][:categories].each do |category_id|
        #   search_targets_attributes << { target_type: "Category", target_id: category_id.to_i }
        # end
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
end
