require 'rspec'
require_relative '../lib/checkout'
require_relative '../lib/product'
require_relative '../lib/validations/validator'
require_relative '../lib/validations/green_tea_validator'
require_relative '../lib/validations/strawberry_validator'
require_relative '../lib/validations/coffee_validator'

RSpec.describe Checkout do
  let(:products) do
    {
      'GR1' => Product.new('GR1', 'Green Tea', 3.11),
      'SR1' => Product.new('SR1', 'Strawberries', 5.00),
      'CF1' => Product.new('CF1', 'Coffee', 11.23)
    }
  end

  let(:validator) do
    Validations::Validator.new.tap do |v|
      v.add_validator(Validations::GreenTeaValidator.new)
      v.add_validator(Validations::StrawberryValidator.new)
      v.add_validator(Validations::CoffeeValidator.new)
    end
  end

  it 'calculates the total for a mixed basket with discounts' do
    checkout = Checkout.new(validator)
    checkout.scan(products['GR1'])
    checkout.scan(products['SR1'])
    checkout.scan(products['GR1'])
    checkout.scan(products['GR1'])
    checkout.scan(products['CF1'])
    expect(checkout.total).to eq(22.45)
  end

  it 'calculates the total for a basket with only green tea' do
    checkout = Checkout.new(validator)
    checkout.scan(products['GR1'])
    checkout.scan(products['GR1'])
    expect(checkout.total).to eq(3.11)
  end

  it 'calculates the total for a basket with strawberries and green tea' do
    checkout = Checkout.new(validator)
    checkout.scan(products['SR1'])
    checkout.scan(products['SR1'])
    checkout.scan(products['GR1'])
    checkout.scan(products['SR1'])
    expect(checkout.total).to eq(16.61)
  end

  it 'calculates the total for a basket with coffee and other items' do
    checkout = Checkout.new(validator)
    checkout.scan(products['GR1'])
    checkout.scan(products['CF1'])
    checkout.scan(products['SR1'])
    checkout.scan(products['CF1'])
    checkout.scan(products['CF1'])
    # expect(checkout.total).to eq(30.57)
    expect(checkout.total).to be_within(0.01).of(30.57)

  end
end
