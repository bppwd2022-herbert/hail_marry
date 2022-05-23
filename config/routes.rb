Rails.application.routes.draw do
  

  resources :rentals
  resources :items
  get 'user_management/assign_roles'
  # patch 'user_management/assign_roles'
  patch 'user_management/update'
  get 'user_management/show'
  patch 'user_management/update_resource'
  get 'user_management/edit'
  get 'user_management/new'
  post 'user_management/create'
  resources :roles
  get 'home/index'
  devise_for :users, :controllers => { :registrations => "users/registrations" }, :path_prefix => 'my'
  resources :users
  as :user do
    get "/register", to: "registrations#new", as: "register"
  end

  root to: "home#index"

end
