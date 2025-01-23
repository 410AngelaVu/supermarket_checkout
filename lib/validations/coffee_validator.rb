require_relative '../errors/validation_errors'

module Validations
  class CoffeeValidator
    MAX_COFFEE = 5_000

    def initialize(validator, threshold, discount_factor)
      @validator = validator
      @threshold = threshold
      @discount_factor = discount_factor
    end

    def apply(cart)
      validate_coffee(cart)
      return cart unless eligible_for_discount?(cart)

      cart.map { |item| discount_item_if_coffee(item) }
    end

    private

    def eligible_for_discount?(cart)
      @validator.count_items(cart, 'CF1') >= @threshold
    end

    def discount_item_if_coffee(item)
      item.code == 'CF1' ? @validator.discounted_item(item, calculate_discounted_price(item.price)) : item
    end

    def calculate_discounted_price(price)
      (price * @discount_factor).round(2)
    end

    def validate_coffee(cart)
      coffee_count = @validator.count_items(cart, 'CF1')

      if coffee_count > MAX_COFFEE
        raise Errors::ValidationError, "Cannot purchase more than #{MAX_COFFEE} coffee items at a time."
      end
    end
  end
end
