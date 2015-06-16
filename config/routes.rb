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
    get     "login"   => :new
    post    "login"   => :create
    delete  "logout"  => :destroy
  end

  shallow do
    resources :users, except: [:index, :show, :destroy] do
      resources :searches, except: [:index, :edit, :update]
    end
  end

  shallow do
    resources :accounts, except: [:show] do
      resources :categories,    except: [:show] { post "import_from", on: :collection }
      resources :transactions,  except: [:show] { post "easycheck",   on: :member }
      resources :schedules,     except: [:show] { post "insert",      on: :member }
    end
  end

  root "dashboard#index", as: "dashboard"
end
