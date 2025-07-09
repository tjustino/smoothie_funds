require "write_xlsx"

# Application Controller
class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern

  before_action :check_granted_access_and_set_variables, if: :authenticated?

  private ##############################################################################################################

    def load_limit
      @limit = params[:limit].nil? ? 20 : params[:limit].to_i.abs
    end

    def timestamp_for_export
      Time.zone.today.strftime("%Y%m%d")
    end

    def set_current_account
      if params[:account_id].present?
        @current_account = Account.find(params[:account_id].to_i)
      else
        id = params[:id].to_i

        case controller_name
        when "categories"
          @current_account = Category.find(id).account
        when "transactions"
          @current_account = Transaction.find(id).account
        when "schedules"
          @current_account = Schedule.find(id).account
        else
          redirect_to dashboard_url
        end
      end
    end

    def userstamp(obj)
      obj.update(created_by: @current_user.id) if params[:action] == "create" || params[:action] == "import_from"
      obj.update(updated_by: @current_user.id)
    end

    def check_granted_access_and_set_variables
      if valid_conditions?
        @current_user = Current.user
        @current_accounts = @current_user.accounts.active.order_by_name
        @accounts_with_categories = Account.where(id: @current_user.categories.pluck(:account_id)).active.order_by_name
      else
        redirect_to dashboard_url
      end
    end

    def valid_conditions?
      good_id?                                       ||
      good_account_id?                               ||
      good_user_id?                                  ||
      %w[dashboard rights].include?(controller_name) ||
      [
        [ "accounts", "index" ],
        [ "accounts", "create" ],
        [ "accounts", "new" ],
        [ "accounts", "sharing" ],
        [ "accounts", "unsharing" ],
        [ "sessions", "destroy" ]
      ].include?([ controller_name, action_name ])
    end

    def good_id?
      return false unless params[:id].present?

      id = params[:id].to_i

      if controller_name == "users"
        id == Current.user.id
      elsif %w[categories transactions schedules accounts searches].include?(controller_name)
        Current.user.send(controller_name).ids.include? id
      else
        false
      end
    end

    def good_account_id?
      params[:account_id].present? && Current.user.accounts.ids.include?(params[:account_id].to_i)
    end

    def good_user_id?
      params[:user_id].present? && params[:user_id].to_i == Current.user.id
    end
end
