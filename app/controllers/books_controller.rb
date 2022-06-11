class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[ show edit update destroy ]

  def index
    authorize :dashboard, :index?
    @books = Book.all
    @availables = is_available
  end

  def show
  authorize :dashboard, :show?
    @rentals = @book.rentals.all
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
    authorize :dashboard, :new?
    @book = Book.new
  end

  def edit
    authorize @book, :mid?
  end

  def create
    authorize :book, book_params[:teacher]
    @book = Book.new(book_params)
    @book.name = @book.title + " by " + @book.author + " (" + @book.year.to_s + " Edition)"
    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize :dashboard, :update?
    @book.name = @book.title + " by " + @book.author + " (" + @book.year.to_s + " Edition)"
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize :dashboard, :destroy?
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def is_available
    @books = Book.all
    available_books = []
    @books.each do |bookx|
      book_rentals = Rental.where(rentable_type: "Book", rentable_id: bookx.id)
      
      available = true
      book_rentals.each do |rentalx|
        if rentalx.return_date.nil? || rentalx.return_date.future?
          available = false
        end
      end
      available_books << available
    end
    return available_books
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:isbn_number, :creator, :title, :notes, :teacher, :author, :year)
    end
end
