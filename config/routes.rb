Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :brands
  resources :roles
  resources :users
  resources :products, only: [:create]
  put '/brands/:brand_id/products/:product_id', to: 'products#update'
  post '/sessions', to: 'sessions#login'

end
