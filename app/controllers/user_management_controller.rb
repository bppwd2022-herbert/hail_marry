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
    @roles = Role.all
    # params  @user.password_confirmation
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_management_show_path(id: @user.id), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params[user.password]&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end
  def update

    if URI(request.referer).path == '/user_management/edit'
      @user = User.find(params[:id])
    elsif URI(request.referer).path == '/user_management/create'
      @user = params[:user]
    end

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





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:id, :email, :password, :id_number, :name, :phone, :password_confirmation)
    end

end