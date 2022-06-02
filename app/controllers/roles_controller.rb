class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_role, only: %i[ show edit update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :go_home
  # GET /roles or /roles.json
  def index
    @roles = Role.all
    authorize :dashboard, :index?
  end

  # GET /roles/1 or /roles/1.json
  def show
    @role = Role.find(params[:id])
    authorize @role
  end

  # GET /roles/new
  def new
    @role = Role.new
    authorize :dashboard, :new?
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
    authorize @role
  end

  # POST /roles or /roles.json
  def create
    authorize :dashboard, :create?
    @role = Role.new(role_params)
    respond_to do |format|
      if @role.save
        format.html { redirect_to role_url(@role), notice: "Role was successfully created." }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    authorize @role
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to role_url(@role), notice: "Role was successfully updated." }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    authorize @role
    @role.destroy

    respond_to do |format|
      format.html { redirect_to roles_url, notice: "Role was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def go_home
    flash[:alert] = "Role not found."
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_params
      params.require(:role).permit(:name, :description)
    end
end
