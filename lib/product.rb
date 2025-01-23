class Product
  attr_accessor :price
  attr_reader :code, :name

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end
end
