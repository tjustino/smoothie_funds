# frozen_string_literal: true

require "csv"

# Application Controller
class ApplicationController < ActionController::Base
  #                       +-------+-------+-------+-------+-------+----------+
  #                       | Accou | Categ | Sched | Sessi | Trans | Users    |
  # +---------------------+-------+-------+-------+-------+-------+----------+
  # | authorize           |   1   |   1   |   1   |   1   |   1   | 1        |
  # +---------------------+-------+-------+-------+-------+-------+----------+
  # | set_current_user    |   1   |   1   |   1   |   X   |   1   | X n&c, 1 |
  # +---------------------+-------+-------+-------+-------+-------+----------+
  # | set_current_accounts|   1   |   1   |   1   |   X   |   1   | X n&c, 1 |
  # +=====================+=======+=======+=======+=======+=======+==========+
  # | set_current_account |       |   1   |   1   |       |   1   |          |
  # +---------------------+-------+-------+-------+-------+-------+----------+

  # respect this order for the authorize method that call @current_user
  before_action :set_current_user,
                :set_current_accounts,
                :set_accounts_with_categories,
                :authorize

  private ##############################################################################################################

    def load_limit
      @limit = params[:limit].nil? ? 20 : params[:limit].to_i.abs
    end

    def timestamp_for_export
      Time.zone.today.strftime("%Y%m%d")
    end

    def set_current_user
      @current_user = User.find_by(id: session[:user_id])
    end

    def set_current_accounts
      return unless @current_user

      @current_accounts = @current_user.accounts.active.order_by_name
    end

    def set_current_account
      if params[:account_id].present?
        @current_account = Account.find(params[:account_id])
      else
        case controller_name
        when "categories"
          @current_account = Category.find(param_id).account
        when "transactions"
          @current_account = Transaction.find(param_id).account
        when "schedules"
          @current_account = Schedule.find(param_id).account
        end
      end
    end

    def set_accounts_with_categories
      return unless @current_user

      accounts = @current_user.categories.select(:account_id)
      @accounts_with_categories = Account.active.where(id: accounts).order_by_name
    end

    def userstamp(obj)
      obj.update(created_by: @current_user.id) if params[:action] == "create" || params[:action] == "import_from"
      obj.update(updated_by: @current_user.id)
    end

    def authorize
      if user_connected?
        redirect_to dashboard_url unless granted_urls_logged_user?
      else
        redirect_to login_url unless granted_urls_not_logged_user?
      end
    end

    def user_connected?
      @current_user.present?
    end

    def controller_action?(controller, action)
      (controller_name == controller) && (action_name == action)
    end

    def granted_urls_not_logged_user?
      controller_action?("users", "new")      ||
        controller_action?("users", "create") ||
        controller_name == "sessions"         ||
        controller_name == "rights"
    end

    def granted_urls_logged_user?
      controller_action?("dashboard", "index")       ||
        controller_action?("accounts",  "index")     ||
        controller_action?("accounts",  "create")    ||
        controller_action?("accounts",  "new")       ||
        controller_action?("accounts",  "sharing")   ||
        controller_action?("accounts",  "unsharing") ||
        controller_name == "rights"                  ||
        good_account_id?                             ||
        good_user_id?                                ||
        good_id?
    end

    def good_account_id?
      if params[:account_id].present?
        @current_accounts.ids.include? params[:account_id].to_i
      else
        false
      end
    end

    def good_user_id?
      if params[:user_id].present?
        @current_user.id == params[:user_id].to_i
      else
        false
      end
    end

    def good_id?
      if params[:id].present?
        case controller_name
        when "users"
          param_id == @current_user.id
        when "categories"
          Category.where(account_id: @current_accounts).ids.include? param_id
        when "transactions"
          Transaction.where(account_id: @current_accounts).ids.include? param_id
        when "schedules"
          Schedule.where(account_id: @current_accounts).ids.include? param_id
        when "accounts"
          @current_user.accounts.ids.include? param_id
        when "searches"
          @current_user.searches.ids.include? param_id
        end
      else
        false
      end
    end

    def param_id
      params[:id].to_i
    end
end
