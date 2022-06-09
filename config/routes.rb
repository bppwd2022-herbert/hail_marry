Rails.application.routes.draw do
  
  resources :vans
  resources :books
  resources :rentals
  resources :items
  # get 'rental/get_rentable'
  get 'user_management/assign_roles'
  patch 'user_management/update'
  get 'user_management/show'
  # patch 'user_management/update_resource'
  get 'user_management/edit'
  get 'user_management/create'
  post 'user_management/update'
  get 'user_management/new'
  post 'user_management/create'
  get 'item/available'
  resources :roles
  get 'home/index'
  get 'user_management/find_current_user'
  devise_for :users, :controllers => { :registrations => "users/registrations" }, :path_prefix => 'my'
  resources :users
  as :user do
    get "/register", to: "registrations#new", as: "register"
  end

  root to: "home#index"

end
