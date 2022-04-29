class Users::RegistrationsController < Devise::RegistrationsController
  # def create
  #   # Your custom code here. Make sure you copy devise's functionality
  # end

  private

  # Notice the name of the method
  def sign_up_params
    params.require(:user).permit(:name, :id_number, :phone, :email, :password, :password_confirmation)
  end
end