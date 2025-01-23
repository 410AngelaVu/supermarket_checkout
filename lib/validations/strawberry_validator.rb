module Validations
  class StrawberryValidator
    def apply(cart)
      strawberries = cart.select { |item| item.code == 'SR1' }
      strawberries.each { |item| item.price = 4.50 } if strawberries.size >= 3
    end
  end
end
