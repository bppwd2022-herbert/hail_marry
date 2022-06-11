class VansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_van, only: %i[ show edit update destroy ]

  def index
    @vans = Van.all
    @availables = is_available
  end

  def show
    @rentals = Rental.where(rentable_id: params[:id])
    @available = true
    @rentals.each do |rentalx|
      if rentalx.return_date.nil?
        @available = false
      else
        if rentalx.return_date.future?
          @available = false
        end
      end
    end
  end

  def new
    @van = Van.new
  end

  def edit
  end

  def create
    @van = Van.new(van_params)
    @van.name = @van.vyear.to_s + " " + @van.vmake + " " + @van.vmodel
    respond_to do |format|
      if @van.save
        format.html { redirect_to van_url(@van), notice: "Van was successfully created." }
        format.json { render :show, status: :created, location: @van }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @van.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @van.name = @van.vyear.to_s + " " + @van.vmake + " " + @van.vmodel
      if @van.update(van_params)
        format.html { redirect_to van_url(@van), notice: "Van was successfully updated." }
        format.json { render :show, status: :ok, location: @van }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @van.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @van.destroy

    respond_to do |format|
      format.html { redirect_to vans_url, notice: "Van was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def is_available
    @vans = Van.all
    available_vans = []
    @vans.each do |vanx|
      van_rentals = Rental.where(rentable_type: "Van", rentable_id: vanx.id)
      available = true
      van_rentals.each do |rentalx|
        if rentalx.return_date.nil? || rentalx.return_date.future?
          available = false
        end
      end
      available_vans << available
    end
    return available_vans
  end

  private
    def set_van
      @van = Van.find(params[:id])
    end

    def van_params
      params.require(:van).permit(:vyear, :vmake, :vmodel, :notes)
    end
end
