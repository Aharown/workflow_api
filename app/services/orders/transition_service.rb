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
      unless @order.aasm.events(permitted: true).map(&:name).include?(@event.to_sym)
        raise AASM::InvalidTransition, "Event '#{@event}' not allowed from current state"
      end

      @order.public_send("#{@event}!")
      @order
    end
  end
end
