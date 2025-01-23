require 'rspec'
require_relative '../lib/product'

RSpec.describe Product do
  it 'creates a product with code, name, and price' do
    product = Product.new('GR1', 'Green Tea', 3.11)
    expect(product.code).to eq('GR1')
    expect(product.name).to eq('Green Tea')
    expect(product.price).to eq(3.11)
  end
end
