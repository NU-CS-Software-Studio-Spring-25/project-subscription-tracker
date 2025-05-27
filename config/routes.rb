Rails.application.routes.draw do
  devise_for :users
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
end
