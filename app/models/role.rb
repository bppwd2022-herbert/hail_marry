class Role < ApplicationRecord
    has_and_belongs_to_many :users, :inverse_of => :role
end
