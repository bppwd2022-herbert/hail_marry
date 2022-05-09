class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :rentals
  has_many :items, through: :rentals
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
