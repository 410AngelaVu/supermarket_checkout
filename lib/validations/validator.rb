module Validations
  class Validator
    MAX_BUY_ITEMS = 100_000

    def initialize
      @validators = []
    end

    def add_validator(validator)
      @validators << validator
    end

    def remove_validator(validator)
      @validators.delete(validator)
    end

    def apply(cart)
      validate_cart(cart)
      @validators.inject(cart) { |updated_cart, validator| validator.apply(updated_cart) }
    end

    def count_items(cart, code)
      cart.count { |item| item.code == code }
    end

    def discounted_item(item, new_price)
      Product.new(item.code, item.name, new_price)
    end

    private

    def validate_cart(cart)
      if cart.size > MAX_BUY_ITEMS
        raise Errors::ValidationError, "Cart exceeds maximum allowed items #{MAX_BUY_ITEMS}."
      end
    end
  end
end
