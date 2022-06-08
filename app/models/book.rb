class Book < ApplicationRecord
    has_many :rentals, as: :rentable, dependent: :destroy
    has_many :users, through: :rentals
end
