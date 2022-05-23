class Users::RegistrationsController < Devise::RegistrationsController
  # def create
  #   # Your custom code here. Make sure you copy devise's functionality
  # end
  skip_before_action :require_no_authentication, only: [:new, :create, :cancel, :update, :edit]

  # def check_permissions
  #   authorize! :create, resource
  # end

  def new
    super
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        # set_flash_message! :notice, :signed_up
        # sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    render :edit
  end


  def destroy
    User.find(params[:id]).destroy
    set_flash_message! :notice, :destroyed
    yield @cu if block_given?
    respond_with_navigational(@cu){ redirect_to user_management_assign_roles_path }
  end



  private

  # Notice the name of the method
  def sign_up_params
    params.require(:user).permit(:name, :id_number, :phone, :email, :password, :password_confirmation)
  end
end