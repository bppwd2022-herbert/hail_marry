Rails.application.routes.draw do
  

  resources :rentals
  resources :items
  get 'user_management/assign_roles'
  post 'user_management/assign_roles'

  get 'user_management/show'
  get 'user_management/edit'
  get 'user_management/new'
  resources :roles
  get 'home/index'
  devise_for :users, :controllers => { :registrations => "users/registrations" }, :path_prefix => 'my'
  resources :users

  as :user do
    get "/register", to: "registrations#new", as: "register"
  end

  root to: "home#index"

end
