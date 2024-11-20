class Business < ApplicationRecord
  has_many :products
  has_many :supplies
  has_many :orders
  has_many :users
end
