json.extract! user, :email, :password, :id_number, :name, :phone, :created_at, :updated_at
json.url user_url(user, format: :json)
