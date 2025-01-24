# Supermarket Checkout System

A simple checkout system built in Ruby for a supermarket chain, featuring pricing rules such as "Buy One Get One Free" for green tea, bulk discounts for strawberries, and a reduced price for coffee when buying three or more.

This project adheres to **TDD principles**, ensuring robust and maintainable code.

---

## Features

- **Product Scanning**: Dynamically add items to the cart with quantity support.
- **Pricing Rules**:
  - **Green Tea**: Buy One Get One Free (BOGO).
  - **Strawberries**: Bulk discount (reduced price when buying 3 or more).
  - **Coffee**: Reduced unit price when purchasing 3 or more items.
- **Edge Case Handling**: Handles empty carts, invalid inputs, and various discount combinations.
- **Comprehensive Tests**: All pricing rules and scenarios are tested in `checkout_spec.rb`.

---

## Pricing Rules

### **Green Tea (BOGO)**
- **Description**: For every green tea purchased, the customer receives one free.
- **Example**: 
  - Buy 4 green teas → Pay for 2.
  - Total price: `2 × 3.11 = 6.22`

---

### **Strawberries (Bulk Discount)**
- **Description**: If 3 or more strawberries are purchased, their price is reduced to $4.50 each.
- **Example**: 
  - Buy 3 strawberries → `3 × 4.50 = 13.50`

---

### **Coffee (Discounted Price for 3+)**
- **Description**: When 3 or more coffees are purchased, the price per coffee is reduced by one-third.
- **Example**: 
  - Buy 3 coffees → `3 × 7.49 = 22.47` (discounted price: `$7.49` each)

---

## Testing

Run the RSpec test suite to ensure everything works as expected:
```bash
rspec
