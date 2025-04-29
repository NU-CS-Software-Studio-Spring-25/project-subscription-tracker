Rails.application.routes.draw do
  resources :subscriptions, only: [:index, :create, :edit, :update, :destroy] do
    collection do
      get :summary   # → GET /subscriptions/summary
    end
  end
  root 'subscriptions#index'  # Makes the subscription page your homepage
end
