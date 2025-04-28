Rails.application.routes.draw do
  resources :subscriptions
  root 'subscriptions#index'  # Makes the subscription page your homepage
end
