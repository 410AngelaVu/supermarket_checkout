module Validations
  class Validator
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
      @validators.each { |validator| validator.apply(cart) }
    end
  end
end
