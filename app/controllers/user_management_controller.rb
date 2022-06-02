class UserManagementController < ApplicationController
  before_action :authenticate_user!
  def assign_roles
    @users = User.all
    @roles = Role.all
    authorize @user, policy_class: UserManagementPolicy
    @status = get_status
  end

  def show
    @user = User.find(params[:id])
    @roles = Role.all
    authorize @user.id, policy_class: UserManagementPolicy
  end

  def new
    @user = User.new
    @roles = Role.all
    authorize :dashboard, :new?
  end

  def edit
    @user = User.find(params[:id])
    @roles = Role.all
    authorize :dashboard, :edit?
  end

  def create
    @without_role = User.new(user_params.except(:role_id, :_method, :authenticity_token, :commit))
    @user = default_role(@without_role)
    @roles = Role.all
    authorize :dashboard, :create?
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

    authorize :dashboard, :update?
    @role = Role.where(id: params[:role_id]).take

    if URI(request.referer).path == '/user_management/edit'
      @user = User.find(params[:id])
    elsif URI(request.referer).path == '/user_management/create'
      @user = params[:user]
    elsif URI(request.referer).path == '/user_management/new'
      @user = params[:user]
    end

    if @role.present?
      @user.roles.clear
      @user.roles << @role
      respond_to do |format|
        format.html { redirect_to user_management_edit_path(id: @user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      end
    else
      respond_to do |format|
        if @user.update(user_params.except(:role_id, :_method, :authenticity_token, :commit))
          format.html { redirect_to user_management_edit_path(id: @user), notice: "User was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def default_role(new_user)
    with_role = new_user
    with_role.roles << Role.where(name: 'Student').first
    return with_role
  end

  def find_current_user
    @current_user ||= User.find_by(id: session[:user_id])
    return @current_user
  end

  def get_status
    @users = User.all
    @rentals = Rental.all
    @items = Item.all
    stat_arr = []
    @users.each do |userx|
      if userx.rentals.present?
        users_late_items = ""
        counter = -3
        userx.rentals.each do |rentalx|
          if rentalx.estimatte_return_date.nil? || rentalx.estimatte_return_date.past?
            if rentalx.return_ate.nil?
              users_late_items << rentalx.item.name + ", "
              counter += 1
            end
          end
        end
        if users_late_items.empty?
          stat_arr << "No Late Items"
        else
          stat_arr << users_late_items[0...counter]
        end
      else
        stat_arr << "No Rented Items"
      end
    end
    return stat_arr
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:_method, :role, :id, :email, :password, :id_number, :name, :phone, :password_confirmation, :authenticity_token, :commit)
    end
    def update_params
      params.permit(:role_id, :user, :_method, :role, :id, :email, :password, :id_number, :name, :phone, :password_confirmation, :authenticity_token, :commit)
    end
end