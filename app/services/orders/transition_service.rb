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
      OrderEvent.create!(
        order: @order,
        event_type: @event,
        metadata: {
          state: @order.state,
          user_id: @user&.id             
        }
      )
      @order
    end
  end
end
