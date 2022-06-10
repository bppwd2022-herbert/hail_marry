json.extract! book, :id, :isbn_number, :title, :notes, :teacher, :author, :year, :created_at, :updated_at
json.url book_url(book, format: :json)