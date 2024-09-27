class SupplyList < ApplicationRecord
  belongs_to :product
  has_and_belongs_to_many :supplies
end
