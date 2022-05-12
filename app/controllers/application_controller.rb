class ApplicationController < ActionController::Base
    include Pundit::Authorization
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :user_full_name

    def user_full_name
      if user_signed_in?
        @user_name = current_user.name
      else
        @user_name = "Guest"
      end
    end
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :id_number, :phone, :email, :password, :password_confirmation)}

      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :id_number, :phone, :email, :password, :password_confirmation, :current_password)}
    end
  end