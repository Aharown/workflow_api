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
      previous_state = @order.state

      @order.public_send("#{@event}!")
      OrderEvent.create!(
        order: @order,
        event_type: @event,
        metadata: {
          from: previous_state,
          to: @order.state
        }
      )
      @order
    end
  end
end
