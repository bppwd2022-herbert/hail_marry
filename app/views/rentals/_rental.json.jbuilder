json.extract! rental, :id, :condition, :return_date, :estimate_return_date, :rented_date, :user_id, :rentable_id, rentable_type, :created_at, :updated_at
json.url rental_url(rental, format: :json)
