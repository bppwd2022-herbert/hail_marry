class UserManagementController < ApplicationController
  def assign_roles
    @users = User.all
    @roles = Role.all
  end



  def show
    @user = User.find(params[:id])
    @roles = Role.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])

    # params  @user.password_confirmation
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params["password"]&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end
  def update
    @user = User.find(params[:id])
    respond_to do |format|

      if @user.update(user_params)
        format.html { redirect_to user_management_show_path(id: @user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to cancel_user_registration_path, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:id, :email, :password, :id_number, :name, :phone, :current_password, :password_confirmation)
    end

end