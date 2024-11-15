class Business < ApplicationRecord
  belongs_to :user
  has_many :products
  has_many :supplies
  has_many :orders
end
