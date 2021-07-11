# frozen_string_literal: true

# Service object to store information and methods related to products
class ProductBox
  ### Constants
  ALL_PRODUCTS = [
    { name: 'Cola', price: 1.25, quantity: 2 },
    { name: 'Fanta', price: 1.50, quantity: 3 },
    { name: 'Sprite', price: 1, quantity: 1 }
  ].freeze

  ### Public Class Methods
  class << self
    attr_accessor :selected_product

    def products
      @products ||= ALL_PRODUCTS
    end

    def available_products
      products.find_all { |product| (product[:quantity]).positive? }
    end

    def return_product
      selected_product[:quantity] -= 1
      selected_product[:name]
    end
  end
end
