class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
    @availables = is_available
    authorize :dashboard, :index?
  end

  # GET /books/1 or /books/1.json
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

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
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

  # PATCH/PUT /books/1 or /books/1.json
  def update
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

  # DELETE /books/1 or /books/1.json
  def destroy
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
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:isbn_number, :title, :notes, :teacher, :author, :year)
    end
end
