class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize, :set_current_user, :set_current_accounts
  helper_method :current_user, :current_accounts

  protected
    def current_user
      User.find_by(id: session[:user_id])
    end

    def set_current_user
      @current_user = current_user
    end

    def current_accounts
      current_user.accounts.order(:name)
    end

    def set_current_accounts
      @current_accounts = current_accounts
    end

    def set_current_account
      @current_account = Account.find(params[:account_id])
    end

    def authorize
      unless  current_user ||
              ( params[:controller] == "users" && params[:action] == "new" ) ||
              ( params[:controller] == "users" && params[:action] == "create" )
        redirect_to login_url
      end
    end
end
