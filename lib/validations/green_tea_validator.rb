module Validations
  class GreenTeaValidator
    def initialize(validator)
      @validator = validator
    end

    def apply(cart)
      apply_green_tea_discount(cart)
    end

    private

    def apply_green_tea_discount(cart)
      green_tea_count = 0

      cart.map do |item|
        if item.code == 'GR1'
          green_tea_count += 1
          process_green_tea_item(item, green_tea_count)
        else
          item
        end
      end
    end

    def process_green_tea_item(item, count)
      free_item?(count) ? @validator.discounted_item(item, 0) : item
    end

    def free_item?(index)
      index.even?
    end
  end
end
