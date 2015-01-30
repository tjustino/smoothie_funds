Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  controller :sessions do
    get     "login"   => :new
    post    "login"   => :create
    delete  "logout"  => :destroy
  end

  resources :users, except: [:index, :show] do
    resources :accounts, except: [:show] do
      resources :categories,    except: [:show] { post "import_from", on: :collection }
      resources :transactions,  except: [:show] { post "easycheck", on: :member }
      resources :schedules,     except: [:show] { post "insert", on: :member }
    end
  end

  root "dashboard#index", as: "dashboard"
end
