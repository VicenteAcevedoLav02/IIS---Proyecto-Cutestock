class Order < ApplicationRecord
  belongs_to :business
  has_one :product_list, dependent: :destroy
  has_many :products, through: :product_list

  #after_update :send_order_state_changed_email, if: :state_changed?

  def total_supplies_needed
    total_needed = Hash.new(0)

    products.each do |product|
      product.supply_list.supplies.each do |supply|
        total_needed[supply] += supply.minimum_needs
      end
    end

    total_needed
  end

  def total_supply_cost
    total_supplies_needed.sum do |supply, total_needed|
      supply.cost * total_needed
    end
  end

  private

  def state_changed?
    saved_change_to_state?
  end

  def state_was
    state_before_last_save
  end

  #def send_order_state_changed_email
  #  OrderMailer.state_changed(
  #    self, 
  #    state_was, 
  #    current_user.email
  #  ).deliver_later
  #end
end