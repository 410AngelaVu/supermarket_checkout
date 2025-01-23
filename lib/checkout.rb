class Checkout
  def initialize(validator)
    @validator = validator
    @cart = []
  end

  def scan(product, quantity = 1)
    validate_item(product, quantity)
    quantity.times { @cart << product }
  end

  def total
    validated_cart = @validator.apply(@cart)
    validated_cart.sum(&:price).round(2)
  end

  def validate_item(product, quantity = 1)
    raise ArgumentError, 'Invalid item name' unless product.is_a?(Product)
    raise ArgumentError, 'Quantity must be positive' unless quantity.is_a?(Integer) && quantity > 0
  end
end
