class Product < ApplicationRecord
  belongs_to :business
  has_one :supply_list
  has_many :supplies, through: :supply_list
end
