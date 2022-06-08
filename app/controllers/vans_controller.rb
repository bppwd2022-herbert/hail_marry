class VansController < ApplicationController
  before_action :set_van, only: %i[ show edit update destroy ]

  # GET /vans or /vans.json
  def index
    @vans = Van.all
    @availables = is_available
  end

  # GET /vans/1 or /vans/1.json
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

  # GET /vans/new
  def new
    @van = Van.new
  end

  # GET /vans/1/edit
  def edit
  end

  # POST /vans or /vans.json
  def create
    @van = Van.new(van_params)

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

  # PATCH/PUT /vans/1 or /vans/1.json
  def update
    respond_to do |format|
      if @van.update(van_params)
        format.html { redirect_to van_url(@van), notice: "Van was successfully updated." }
        format.json { render :show, status: :ok, location: @van }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @van.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vans/1 or /vans/1.json
  def destroy
    @van.destroy

    respond_to do |format|
      format.html { redirect_to vans_url, notice: "Van was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def is_available
    @vans = Van.all
    puts "===================================="
    if @vans.first.present?
      puts "vans are nill"
    else
      puts @vans.first
    end
    puts "===================================="
    available_vans = []

    @vans.each do |vanx|
      van_rentals = Rental.where(rentable_id: vanx.id, rentable_type: vanx)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_van
      @van = Van.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def van_params
      params.require(:van).permit(:vyear, :vmake, :vmodel, :notes)
    end
end
