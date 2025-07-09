Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  controller :rights do
    get "terms"  => :terms
    get "cookie" => :cookie
    get "gdpr"   => :gdpr
  end

  controller :sessions do
    get    "login"  => :new
    post   "login"  => :create
    delete "logout" => :destroy
  end
  resources :passwords, param: :token, except: %i[ index show destroy ]

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
