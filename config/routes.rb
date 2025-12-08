Rails.application.routes.draw do
  devise_for :users

  scope :admin, module: "back", as: "admin" do
    resources :products

    resources :sales, only: [ :index, :show, :new, :create ] do
      patch :cancel, on: :member
      get :invoice, on: :member
    end

    resources :reports, only: [] do
      collection do
        get :sales_summary
        get :top_products
        get :sales_by_employee
      end
    end

    resources :users
    get "/", to: "admin#index", as: :dashboard
  end

  resources :products, only: [ :index, :show ], module: "storefront"

  resource :profile, only: [ :show, :update ]

  # Legacy route removed in favor of admin scope above
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
