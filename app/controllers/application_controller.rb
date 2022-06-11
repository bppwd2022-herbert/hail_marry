class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :user_full_name
  before_action :role_check
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_full_name
    if user_signed_in?
      @user_name = current_user.name
      @user_id = current_user.id
      @usrole = current_user.roles.first
    else
      @user_name = "Guest"
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to home_index_path
  end

  def role_check
    if @user_name != "Guest"
      @user = User.find(@user_id)
      if @user.roles.first.nil?
        @user.roles << Role.where(name: "Student").first
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :id_number, :phone, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :id_number, :phone, :email, :password, :password_confirmation, :current_password)}
  end

  
end