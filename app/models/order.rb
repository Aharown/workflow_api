class Order < ApplicationRecord
  include AASM
  aasm column: 'status' do

    state :pending, initial: true
    state :confirmed
    state :shipped
    state :delivered
    state :cancelled

   

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :ship do
      transitions from: :confirmed, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :cancel do
      transitions from: [:pending, :confirmed], to: :cancelled
    end
  end
end
