require 'byebug'

module Validations
  class GreenTeaValidator
    def apply(cart)
      green_teas = cart.select { |item| item.code == 'GR1' }
      green_teas.each_slice(2) do |pair|
        pair.last.price = 0 if pair.size == 2
      end
    end
  end
end
