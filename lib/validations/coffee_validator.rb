module Validations
  class CoffeeValidator
    def apply(cart)
      coffees = cart.select { |item| item.code == 'CF1' }
      if coffees.size >= 3
        coffees.each do |item|
          discounted_price = (item.price * 2 / 3.0).round(2)
          item.price = discounted_price.round(2) # Double round to ensure no artifacts
        end
      end
    end
  end
end
