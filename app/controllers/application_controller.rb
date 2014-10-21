class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize, :set_current_user, :set_current_accounts

  private
    def current_user
      User.find_by(id: session[:user_id])
    end

    def set_current_user
      @current_user = current_user
    end

    def set_current_accounts
      @current_accounts = current_user.accounts.active.order_by_name
    end

    def set_current_account
      @current_account = Account.find(params[:account_id])
    end

    def userstamp(obj)
      obj.update_attribute(:created_by, @current_user.id) if params[:action] == "create"
      obj.update_attribute(:updated_by, @current_user.id)
    end

    def authorize
      unless  current_user ||
              ( params[:controller] == "users" && params[:action] == "new" ) ||
              ( params[:controller] == "users" && params[:action] == "create" )
        redirect_to login_url
      end
    end
end
