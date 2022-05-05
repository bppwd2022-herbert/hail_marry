Rails.application.routes.draw do
  

  get 'user_management/assign_roles'
  resources :roles
  get 'home/index'
  devise_for :users
  
  root to: "home#index"

end
