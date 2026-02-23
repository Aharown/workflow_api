class Order < ApplicationRecord
  include AASM

  aasm column: "status" do
    state :pending, initial: true
    state :confirmed
    state :shipped
    state :delivered
    state :cancelled

    event :confirm do
      transitions from: :pending,
                  to: :confirmed,
                  guard: :can_confirm?
    end

    event :ship do
      transitions from: :confirmed,
                  to: :shipped,
                  guard: :can_ship?
    end

    event :deliver do
      transitions from: :shipped,
                  to: :delivered
    end

    event :cancel do
      transitions from: [:pending, :confirmed],
                  to: :cancelled,
                  guard: :can_cancel?
    end
  end

  private

  
  def can_confirm?
    !cancelled?
  end


  def can_ship?
    confirmed? && tracking_number.present?
  end


  def can_cancel?
    !shipped? && !delivered?
  end
end
