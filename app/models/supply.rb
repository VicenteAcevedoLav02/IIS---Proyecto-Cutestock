class Supply < ApplicationRecord
  belongs_to :business
  has_and_belongs_to_many :supply_lists

  # Método para obtener el stock disponible (RS: 020)
  def available_stock
    stock
  end

  # Definir necesidades mínimas de suministro (RS: 027)
  def minimum_needs
    requires || 1 # Este es el valor mínimo necesario para un suministro
  end

  # Verifica si el stock está por debajo de las necesidades mínimas (RS: 025)
  def needs_restock?
    stock < minimum_needs
  end
end
