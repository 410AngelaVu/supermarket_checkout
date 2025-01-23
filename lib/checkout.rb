require 'byebug'
require 'bigdecimal'
require 'bigdecimal/util'

class Checkout
  def initialize(validator)
    @validator = validator
    @cart = []
  end

  def scan(item)
    @cart << Product.new(item.code, item.name, item.price)
  end
  

  def total
    @validator.apply(@cart)
  
    # Debugging: Print the cart state after validations
    puts "Cart state after validations:"
    @cart.each { |item| puts "#{item.code}: #{item.price}" }
  
    # Perform summation
    total = @cart.sum(&:price)
  
    total.round(2)
  end
end
