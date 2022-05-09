Rails.application.routes.draw do
  

  resources :rentals
  resources :items
  get 'user_management/assign_roles'
  resources :roles
  get 'home/index'
  devise_for :users
  
  root to: "home#index"

end
