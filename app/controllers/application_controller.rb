class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # respect this order for the authorize method that call @current_user
  before_action :set_current_user, :set_current_accounts, :authorize

  private
    def current_user
      User.find_by(id: session[:user_id])
    end

    def set_current_user
      @current_user = current_user
    end

    def set_current_accounts
      @current_accounts = @current_user.accounts.active.order_by_name if @current_user
    end

    def set_current_account
      @current_account = Account.find(params[:account_id])
    end

    def userstamp(obj)
      if params[:action] == "create" or params[:action] == "import_from"
        obj.update_attribute(:created_by, @current_user.id)
      end
      obj.update_attribute(:updated_by, @current_user.id)
    end

    def authorize
      # This method only redirect exceptions
      #
      #                                +---------------+---------------+
      #                                | not connected |   connected   |
      #  +-----------------------------+---------------+---------------+
      #  | users#new                   |   good url    | dashboard url |
      #  +-----------------------------+---------------+---------------+
      #  | users#create                |   good url    | dashboard url |
      #  +-----------------------------+---------------+---------------+
      #  | login url                   |   good url    | dashboard url |
      #  +-----------------------------+---------------+---------------+
      #  | good user & good account    |   login url   |   good url    |
      #  +-----------------------------+---------------+---------------+
      #  | good user & wrong account   |   login url   | dashboard url |
      #  +-----------------------------+---------------+---------------+
      #  | wrong user & wrong account  |   login url   | dashboard url |
      #  +-----------------------------+---------------+---------------+
      #  | wrong user & good account   |   login url   | dashboard url |
      #  +-----------------------------+---------------+---------------+

      if user_connected?
        redirect_to dashboard_url unless (  dashboard_url? or 
                                            good_user_no_account? or
                                            good_user_good_account? )
      else
        redirect_to login_url unless ( users_new? or users_create? )
      end
    end

    def user_connected?
      not @current_user.blank?
    end

    def users_new?
      params[:controller] == "users" && params[:action] == "new"
    end

    def users_create?
      params[:controller] == "users" && params[:action] == "create"
    end

    def dashboard_url?
      params[:controller] == "dashboard"
    end

    def good_user_no_account?
      ( params[:user_id].to_s == @current_user.id.to_s and params[:account_id].blank? ) or
      ( params[:id].to_s == @current_user.id.to_s and params[:controller] == "users" )
    end

    def good_user_good_account?
      ( params[:user_id].to_s == @current_user.id.to_s if not params[:account_id].blank? ) and
      ( @current_accounts.ids.to_s.include?(params[:account_id].to_s) if not params[:account_id].blank? )
    end
end
