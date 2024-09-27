class Order < ApplicationRecord
  belongs_to :business
  has_one :product_list
  has_many :products, through: :product_list
end
