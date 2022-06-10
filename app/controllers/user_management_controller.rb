class UserManagementController < ApplicationController
  before_action :authenticate_user!
  def assign_roles
    @users = policy_scope(User, policy_scope_class: UserManagementPolicy::Scope)
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
    @roles = policy_scope(Role, policy_scope_class: UserManagementPolicy::Scope)
    if @user.roles.first.nil?
      @role = default_role(@user)
      authorize @user, policy_class: UserManagementPolicy
    else
      @role = Role.where(name: @user.roles.first.name)
      authorize @user, policy_class: UserManagementPolicy
    end
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

  def update
    if URI(request.referer).path == '/user_management/create' || URI(request.referer).path == '/user_management/new'
      @user = params[:user]
    else
      @user = User.find(params[:id])
    end
    if params[:role].present?
      @role = Role.where(id: params[:role][:role_id]).first
      authorize @role, policy_class: UserManagementPolicy
      @user.roles.clear
      @user.roles << @role
      respond_to do |format|
        format.html { redirect_to user_management_edit_path(id: @user), notice: "User's role was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      end
    else
      @role = Role.where(name: @user.roles.first)
      authorize @role, policy_class: UserManagementPolicy
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
    @users = policy_scope(User, policy_scope_class: UserManagementPolicy::Scope)
    @rentals = Rental.all
    stat_arr = []
    @users.each do |userx|
      if userx.rentals.present?
        users_late_objects = ""
        counter = -3
        userx.rentals.each do |rentalx|
          if rentalx.estimate_return_date.nil? || rentalx.estimate_return_date.past?
            if rentalx.return_date.nil?
              users_late_objects << helpers.get_rentable(rentalx).name + ", "
              counter += 1
            end
          end
        end
        if users_late_objects.empty?
          stat_arr << "No Late Items"
        else
          stat_arr << users_late_objects[0...counter]
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
      params.require(:user).permit(:role_id, :_method, :role, :id, :email, :password, :id_number, :name, :phone, :password_confirmation, :authenticity_token, :commit)
    end

    def update_params
      params.permit(:role_id, :user, :_method, :role, :id, :email, :password, :id_number, :name, :phone, :password_confirmation, :authenticity_token, :commit)
    end
end