# app/services/orders/transition_service.rb

module Orders
  class TransitionService
    def self.call(order:, event:)
      new(order, event).call
    end

    def initialize(order, event)
      @order = order
      @event = event
    end

    def call
      @order.public_send("#{@event}!")
      @order
    end
  end
end
