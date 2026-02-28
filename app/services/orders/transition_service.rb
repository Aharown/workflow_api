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
      event_name = @event.to_sym

      return @order unless @order.aasm.may_fire_event?(event_name)

      previous_state = @order.status

      @order.public_send(event_name)
      OrderEvent.create!(
        order: @order,
        event_type: event_name
        metadata: {
          from: previous_state,
          to: @order.status
        }
      )
      trigger_background_jobs(event_name)

      @order
    end

    private

    def trigger_background_jobs(event_name)
      if event_name == :confirm
        PaymentCaptureJob.perform_later(@order.id)
      end
    end

  end
end
