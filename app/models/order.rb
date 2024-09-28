class Order < ApplicationRecord
  belongs_to :business
  has_one :product_list, dependent: :destroy
  has_many :products, through: :product_list
end
