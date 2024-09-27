class Supply < ApplicationRecord
  belongs_to :business
  has_and_belongs_to_many :supply_lists
end
