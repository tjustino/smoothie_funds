class ApplicationController < ActionController::Base
  #                       +-------+-------+-------+-------+-------+----------+
  #                       | Accou | Categ | Sched | Sessi | Trans | Users    |
  # +---------------------+-------+-------+-------+-------+-------+----------+
  # | authorize           |   ✓   |   ✓   |   ✓   |   ✓   |   ✓   | ✓        |
  # +---------------------+-------+-------+-------+-------+-------+----------+
  # | set_current_user    |   ✓   |   ✓   |   ✓   |   X   |   ✓   | X n&c, ✓ |
  # +---------------------+-------+-------+-------+-------+-------+----------+
  # | set_current_accounts|   ✓   |   ✓   |   ✓   |   X   |   ✓   | X n&c, ✓ |
  # +=====================+=======+=======+=======+=======+=======+==========+
  # | set_current_account |       |   ✓   |   ✓   |       |   ✓   |          |
  # +---------------------+-------+-------+-------+-------+-------+----------+

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # respect this order for the authorize method that call @current_user
  before_action :set_current_user,
                :set_current_accounts,
                :set_accounts_with_categories,
                :authorize

private ########################################################################

  def load_limit
    @limit = 20
  end

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def set_current_accounts
    @current_accounts = @current_user.accounts.active.order_by_name if @current_user
  end

  def set_current_account
    unless params[:account_id].blank?
      @current_account = Account.find(params[:account_id])
    else
      case controller_name
        when "categories"
          @current_account = Category.find(params[:id].to_i).account
        when "transactions"
          @current_account = Transaction.find(params[:id].to_i).account
        when "schedules"
          @current_account = Schedule.find(params[:id].to_i).account
      end
    end
  end

  def set_accounts_with_categories
    if @current_user
      accounts = @current_user.categories.select(:account_id)
      @accounts_with_categories =  Account.active
                                          .where(id: accounts)
                                          .order_by_name
    end
  end

  def userstamp(obj)
    if params[:action] == "create" or params[:action] == "import_from"
      obj.update_attribute(:created_by, @current_user.id)
    end
    obj.update_attribute(:updated_by, @current_user.id)
  end

  def authorize
    if user_connected?
      redirect_to dashboard_url unless granted_urls_logged_user?
    else
      redirect_to login_url unless granted_urls_not_logged_user?
    end
  end

  def user_connected?
    not @current_user.blank?
  end

  def controller_action?(controller, action)
    controller_name == controller and action_name == action
  end

  def granted_urls_not_logged_user?
    controller_action?("users",     "new"   ) or
    controller_action?("users",     "create") or
    controller_name == "sessions"
  end

  def granted_urls_logged_user?
    controller_action?("dashboard", "index"     ) or
    controller_action?("accounts",  "index"     ) or
    controller_action?("accounts",  "create"    ) or
    controller_action?("accounts",  "new"       ) or
    controller_action?("accounts",  "sharing"   ) or
    controller_action?("accounts",  "unsharing" ) or
    good_account_id?                              or
    good_user_id?                                 or
    good_id?
  end

  def good_account_id?
    unless params[:account_id].blank?
      @current_accounts.ids.include? params[:account_id].to_i
    else
      false
    end
  end

  def good_user_id?
    unless params[:user_id].blank?
      @current_user.id == params[:user_id].to_i
    else
      false
    end
  end

  def good_id?
    unless params[:id].blank?
      ( controller_name == "users" and 
        params[:id].to_i == @current_user.id )                             or

      ( controller_name == "categories" and 
        Category.where(account_id: @current_accounts).ids
                                              .include? params[:id].to_i ) or

      ( controller_name == "transactions" and 
        Transaction.where(account_id: @current_accounts).ids
                                              .include? params[:id].to_i ) or

      ( controller_name == "schedules" and 
        Schedule.where(account_id: @current_accounts).ids
                                              .include? params[:id].to_i ) or

      ( controller_name == "accounts" and 
        @current_user.accounts.ids.include? params[:id].to_i )             or

      ( controller_name == "searches" and 
        @current_user.searches.ids.include? params[:id].to_i )
    else
      false
    end
  end
end
