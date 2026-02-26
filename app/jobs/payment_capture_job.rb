class PaymentCaptureJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)

    # Simulate external processing
    Rails.logger.info "Capturing payment for Order ##{order.id}..."

    sleep 2 # simulate API delay

    Rails.logger.info "Payment captured for Order ##{order.id}"
  end
end
