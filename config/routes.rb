Rails.application.routes.draw do
  get "categories/index"
  get "categories/show"

  resources :categories, only: [:index]

  resources :subscriptions, only: [:index, :create, :edit, :update, :destroy] do
    collection do
      get :summary   # → GET /subscriptions/summary
    end
  end
  root 'subscriptions#index'  # Makes the subscription page your homepage
end
