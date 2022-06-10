class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[ show edit update destroy ]
  def index
    @items = Item.all
    @rentals = Rental.all
    @availables = is_available
    authorize :dashboard, :index?
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
    authorize :dashboard, :show?
  end

  def new
    @item = Item.new
    authorize :dashboard, :new?
  end

  def edit
    authorize :dashboard, :edit?
  end

  def create
    @item = Item.new(item_params)
    authorize :dashboard, :create?
    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize :dashboard, :update?
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize :dashboard, :destroy?
    @item = Item.find(params[:id])
    @item_rentals = Rental.where(item_id: @item.id)
    @item_rentals.each do |rentalx|
      rentalx.destroy
    end
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def is_available
    @items = Item.all
    available_items = []
    @items.each do |itemx|
      item_rentals = Rental.where(rentable_type: "Item", rentable_id: itemx.id)
      available = true
      item_rentals.each do |rentalx|
        if rentalx.return_date.nil? || rentalx.return_date.future?
          available = false
        end
      end
      available_items << available
    end
    return available_items
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :description, :notes)
    end
end
