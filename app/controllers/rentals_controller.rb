class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: %i[ show edit update destroy ]
  # GET /rentals or /rentals.json
  def index
    @rentals = policy_scope(Rental, policy_scope_class: RentalPolicy::Scope)
    @users = User.all
    @items = Item.all

    authorize @user, policy_class: RentalPolicy
  end

  # GET /rentals/1 or /rentals/1.json
  def show
    @user = User.where(id: @rental.user_id).first
    @rentable = get_rentable(@rental)
    authorize :dashboard, :show?
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
    set_rentable_list
    @role = current_user.roles.first
    authorize :dashboard, :new?
  end

  # GET /rentals/1/edit
  def edit
    authorize :dashboard, :edit?
  end

  # POST /rentals or /rentals.json
  def create
    set_rentable_list
    @rental = Rental.new(rental_params)
    authorize :dashboard, :create?
    respond_to do |format|
      if @rental.save
        format.html { redirect_to rental_url(@rental), notice: "Rental was successfully created." }
        format.json { render :show, status: :created, location: @rental }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rental.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rentals/1 or /rentals/1.json
  def update
    authorize :dashboard, :update?
    respond_to do |format|
      if @rental.update(rental_params)
        format.html { redirect_to rental_url(@rental), notice: "Rental was successfully updated." }
        format.json { render :show, status: :ok, location: @rental }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rental.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rentals/1 or /rentals/1.json
  def destroy
    authorize :dashboard, :destroy?
    @rental.destroy
    respond_to do |format|
      format.html { redirect_to rentals_url, notice: "Rental was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  helper_method :get_rentable
  def get_rentable(rnt)
    @rntable = rnt.rentable_type.constantize.find(rnt.rentable_id)
    puts "================================"
    puts @rntable.name
    puts "================================"
    return @rntable
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental
      @rental = Rental.find(params[:id])
    end

    def set_rentable_list
      # rentable_list = []
      # puts "================================"
      # puts @user.rentables
      # puts "================================"
      # return rentable_list
    end
    # Only allow a list of trusted parameters through.
    def rental_params
      params.require(:rental).permit(:condition, :return_date, :estimate_return_date, :rented_date, :user_id, :rentable_type, :rentable_id)
    end
end
