require 'rspec'
require_relative '../lib/checkout'
require_relative '../lib/product'
require_relative '../lib/validations/validator'
require_relative '../lib/validations/green_tea_validator'
require_relative '../lib/validations/strawberry_validator'
require_relative '../lib/validations/coffee_validator'
require_relative '../lib/errors/validation_errors'

RSpec.describe Checkout do
  let(:products) do
    {
      'GR1' => Product.new('GR1', 'Green Tea', 3.11),
      'SR1' => Product.new('SR1', 'Strawberries', 5.00),
      'CF1' => Product.new('CF1', 'Coffee', 11.23)
    }
  end

  let(:shared_validator) { Validations::Validator.new }

  let(:validator) do
    Validations::Validator.new.tap do |v|
      v.add_validator(Validations::GreenTeaValidator.new(shared_validator))
      v.add_validator(Validations::StrawberryValidator.new(shared_validator))
      v.add_validator(Validations::CoffeeValidator.new(shared_validator, 3, 2 / 3.0))
    end
  end

  subject(:checkout) { described_class.new(validator) }

  describe 'calculating totals for various baskets' do
    context 'with a mixed basket and discounts' do
      it 'calculates the total correctly' do
        checkout.scan(products['GR1'])
        checkout.scan(products['SR1'])
        checkout.scan(products['GR1'])
        checkout.scan(products['GR1'])
        checkout.scan(products['CF1'])
        expect(checkout.total).to eq(22.45)
      end
    end

    context 'with only green tea in the basket' do
      it 'applies the BOGO discount correctly' do
        checkout.scan(products['GR1'])
        checkout.scan(products['GR1'])
        expect(checkout.total).to eq(3.11)
      end
    end

    context 'with strawberries and green tea' do
      it 'applies both discounts correctly' do
        checkout.scan(products['SR1'])
        checkout.scan(products['SR1'])
        checkout.scan(products['GR1'])
        checkout.scan(products['SR1'])
        expect(checkout.total).to eq(16.61)
      end
    end

    context 'with coffee and other items' do
      it 'applies the coffee discount correctly' do
        checkout.scan(products['GR1'])
        checkout.scan(products['CF1'])
        checkout.scan(products['SR1'])
        checkout.scan(products['CF1'])
        checkout.scan(products['CF1'])
        expect(checkout.total).to be_within(0.01).of(30.57)
      end
    end
  end

  describe 'validations' do
    context 'when exceeding maximum item limits' do
      it 'raises a validation error for too many strawberries' do
        strawberries = Array.new(10_001, products['SR1'])
        strawberries.each { |item| checkout.scan(item) }
        expect { checkout.total }.to raise_error(
          Errors::ValidationError,
          "Cannot purchase more than #{Validations::StrawberryValidator::MAX_STRAWBERRY} strawberry items at a time."
        )
      end

      it 'raises a validation error for too many coffees' do
        coffees = Array.new(5_001, products['CF1'])
        coffees.each { |item| checkout.scan(item) }
        expect { checkout.total }.to raise_error(
          Errors::ValidationError,
          "Cannot purchase more than #{Validations::CoffeeValidator::MAX_COFFEE} coffee items at a time."
        )
      end
    end

    context 'when applying validators without matching items' do
      it 'does not raise an error when the cart does not include green tea' do
        checkout.scan(products['SR1'])
        checkout.scan(products['CF1'])
        expect { checkout.total }.not_to raise_error
      end
    end
  end

  describe 'item validation' do
    context 'when valid inputs are provided' do
      it 'accepts a valid product with quantity 1' do
        expect { checkout.scan(products['GR1'], 1) }.not_to raise_error
      end

      it 'accepts a valid product with quantity greater than 1' do
        expect { checkout.scan(products['GR1'], 3) }.not_to raise_error
      end
    end

    context 'when invalid inputs are provided' do
      it 'raises an error for an invalid product' do
        expect { checkout.scan('INVALID_PRODUCT') }.to raise_error(ArgumentError, 'Invalid item name')
      end

      it 'raises an error for a negative quantity' do
        expect { checkout.scan(products['GR1'], -1) }.to raise_error(ArgumentError, 'Quantity must be positive')
      end

      it 'raises an error for a zero quantity' do
        expect { checkout.scan(products['GR1'], 0) }.to raise_error(ArgumentError, 'Quantity must be positive')
      end

      it 'raises an error for a non-integer quantity' do
        expect { checkout.scan(products['GR1'], 'two') }.to raise_error(ArgumentError, 'Quantity must be positive')
      end
    end
  end

  describe 'edge cases' do
    context 'when the cart is empty' do
      it 'returns a total of zero' do
        expect(checkout.total).to eq(0.0)
      end
    end

    context 'when only one item is scanned' do
      it 'calculates the correct total for one green tea' do
        checkout.scan(products['GR1'])
        expect(checkout.total).to eq(3.11)
      end

      it 'calculates the correct total for one strawberry' do
        checkout.scan(products['SR1'])
        expect(checkout.total).to eq(5.00)
      end

      it 'calculates the correct total for one coffee' do
        checkout.scan(products['CF1'])
        expect(checkout.total).to eq(11.23)
      end
    end
  end
end
