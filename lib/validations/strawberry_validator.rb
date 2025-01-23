require_relative '../errors/validation_errors'

module Validations
  class StrawberryValidator
    MAX_STRAWBERRY = 10_000

    def initialize(validator)
      @validator = validator
    end

    def apply(cart)
      validate_strawberries(cart)
      return cart unless eligible_for_discount?(cart)

      cart.map { |item| discount_item_if_strawberry(item) }
    end

    private

    def eligible_for_discount?(cart)
      @validator.count_items(cart, 'SR1') >= 3
    end

    def discount_item_if_strawberry(item)
      item.code == 'SR1' ? @validator.discounted_item(item, 4.50) : item
    end

    def validate_strawberries(cart)
      strawberries_count = @validator.count_items(cart, 'SR1')
      if strawberries_count > MAX_STRAWBERRY
        raise Errors::ValidationError, "Cannot purchase more than #{MAX_STRAWBERRY} strawberry items at a time."
      end
    end
  end
end
