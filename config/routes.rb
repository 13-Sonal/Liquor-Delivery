Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :roles, except: [:destroy]
  resources :users
  resources :products, except: [:destroy]
  resources :orders
  resources :brands
  post '/sessions', to: 'sessions#login'
  post '/brands/:id/product', to: 'products#create'
end

