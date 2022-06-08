class User < ApplicationRecord
  has_and_belongs_to_many :roles, :inverse_of => :user
  
  has_many :rentals
  has_many :vans, through: :rentals, source: :rentable, source_type: 'Van'
  has_many :books, through: :rentals, source: :rentable, source_type: 'Book'
  has_many :item, through: :rentals, source: :rentable, source_type: 'Item'

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
end