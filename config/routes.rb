# frozen_string_literal: true

Rails.application.routes.draw do
  # By default, there is 7 different paths and 7 actions in each controller:
  # +-----------+------------------+-------------------+
  # | HTTP Verb | Path             | Controller#Action |
  # +-----------+------------------+-------------------+
  # | GET       | /photos          | photos#index      |
  # | POST      | /photos          | photos#create     |
  # | GET       | /photos/new      | photos#new        |
  # | GET       | /photos/:id/edit | photos#edit       |
  # | GET       | /photos/:id      | photos#show       |
  # | PATCH/PUT | /photos/:id      | photos#update     |
  # | DELETE    | /photos/:id      | photos#destroy    |
  # +-----------+------------------+-------------------+
  #
  # Resources should never be nested more than 1 level deep
  # With the shallow method, all of the nested resources will be shallow like:
  # +-----------+--------------------------------------+--------------------+
  # | HTTP Verb | Path                                 | Controller#Action  |
  # +-----------+--------------------------------------+--------------------+
  # | GET       | /accounts/:account_id/categories     | categories#index   |
  # | POST      | /accounts/:account_id/categories     | categories#create  |
  # | GET       | /accounts/:account_id/categories/new | categories#new     |
  # | GET       | /categories/:id/edit                 | categories#edit    |
  # | GET       | /categories/:id                      | categories#show    |
  # | PATCH/PUT | /categories/:id                      | categories#update  |
  # | DELETE    | /categories/:id                      | categories#destroy |
  # +-----------+--------------------------------------+--------------------+

  controller :sessions do
    get    "login"  => :new
    post   "login"  => :create
    delete "logout" => :destroy
  end

  controller :rights do
    get "terms"  => :terms
    get "cookie" => :cookie
    get "gdpr"   => :gdpr
  end

  shallow do
    resources :users, except: %i[index show] do
      resources :searches, except: %i[index edit update]
      resources :analytics, only: [ :index ]
    end
  end

  shallow do
    resources :accounts, except: [ :show ] do
      resources :categories, except: [ :show ] do
        post "import_from", on: :collection
      end
      resources :transactions, except: [ :show ] do
        post "easycheck", on: :member
      end
      resources :schedules, except: [ :show ] do
        post "insert", on: :member
      end
    end
  end

  delete "accounts/:id/unlink(.:format)",    to: "accounts#unlink",    as: "unlink"
  delete "accounts/:id/unpend(.:format)",    to: "accounts#unpend",    as: "unpend"
  post   "accounts/:id/sharing(.:format)",   to: "accounts#sharing",   as: "sharing"
  delete "accounts/:id/unsharing(.:format)", to: "accounts#unsharing", as: "unsharing"

  root "dashboard#index", as: "dashboard"
end
