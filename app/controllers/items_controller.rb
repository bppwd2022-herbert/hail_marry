class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[ show edit update destroy ]
  def index
    @items = Item.all
    @rentals = Rental.all
    @rentables = is_rentable
    authorize :dashboard, :index?
  end

  def show
    @rentals = Rental.where(item_id: params[:id])
    @rentable = true
    @rentals.each do |rentalx|
      if rentalx.return_ate.nil?
        @rentable = false
      else
        if rentalx.return_ate.future?
          @rentable = false
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
    @item_rentals = Rental.where(item: @item.id)
    @item_rentals.each do |rentalx|
      rentalx.destroy
    end
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def is_rentable
    @items = Item.all
    rentable_items = []

    @items.each do |itemx|
      item_rentals = Rental.where(item_id: itemx.id)
      rentable = true
      
      item_rentals.each do |rentalx|
        if rentalx.return_ate.nil? || rentalx.return_ate.future?
          rentable = false
        end
      end

      rentable_items << rentable
    end
    return rentable_items
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :description, :notes)
    end
end
