Rails.application.routes.draw do
  resources :categories, only: [:index] do
    collection do
      get :budgeting
    end
  end
  resources :subscriptions, only: [:index, :create, :edit, :update, :destroy] do
    collection do
      get :summary   # → GET /subscriptions/summary
    end
  end
  root 'subscriptions#index'  # Makes the subscription page your homepage
  
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
