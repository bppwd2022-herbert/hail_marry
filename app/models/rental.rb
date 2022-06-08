class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :rentable, polymorphic: true
end
