Rails.application.routes.draw do
  

  resources :rentals
  resources :items
  get 'user_management/assign_roles'
  get 'user_management/show'
  get 'user_management/edit'
  get 'user_management/new'

  as :user do
    get "/register", to: "registrations#new", as: "register"
  end
  # get 'users/registrations'
  resources :roles
  get 'home/index'
  # devise_for :users
  # controllers: {:registrations => "registrations"}
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  # devise_for :users, :path => 'auth', controllers: {registrations: 'users/registrations'}
  resources :users
  root to: "home#index"

end
