Rails.application.routes.draw do
  
  devise_for :users
  devise_scope :user do
    get "/users/sign_in" => "new_user_session_path"
  end
  root to: "devise/sessions#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
