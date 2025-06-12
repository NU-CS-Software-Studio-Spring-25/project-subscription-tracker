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
  root 'subscriptions#summary'  # Makes the subscription page your homepage
  
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
