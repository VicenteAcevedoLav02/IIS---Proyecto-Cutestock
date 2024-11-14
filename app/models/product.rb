class Product < ApplicationRecord
  belongs_to :business
  has_one :supply_list, dependent: :destroy
  has_many :supplies, through: :supply_list

  def profit_margin
    total_supply_cost = supplies.sum(:cost)
    price - total_supply_cost
  end
end
