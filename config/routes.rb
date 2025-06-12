Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  resources :categories, only: [:index] do
    collection do
      get :budgeting
    end
    member do
      patch :update_budget
    end
  end
  
  resources :subscriptions, only: [:index, :create, :edit, :update, :destroy] do
    collection do
      get :summary   # → GET /subscriptions/summary
    end
    member do
      get :price_analysis   # → GET /subscriptions/:id/price_analysis
      get :quick_analysis    # → GET /subscriptions/:id/quick_analysis
    end
  end
  
  # PWA Manifest route
  get "/manifest.json", to: "pwa#manifest", defaults: { format: :json }, as: :pwa_manifest

  # Landing page route
  get "/", to: "pages#landing", as: :landing_page
  
  # Authenticated users go to subscriptions summary
  authenticated :user do
    root 'subscriptions#summary', as: :authenticated_root
  end
  
  # Non-authenticated users see the landing page
  root 'pages#landing'
  
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
