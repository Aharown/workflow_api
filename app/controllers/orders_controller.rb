class OrdersController < ApplicationController

  def create
    order = Order.new(order_params)
    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    order = find_order
    render json: order
  end

  def index
    orders = Order.all
    render json: orders
  end

  def transition
    event = params[:event]
    order = find_order
    return render json: { error: "Missing event" }, status: :unprocessable_entity unless event

    unless order.aasm.events.map(&:name).include?(event.to_sym)
      return render json: { error: "Invalid event" }, status: :unprocessable_entity
    end

    previous_state = order.status

    updated_order = Orders::TransitionService.call(order: order, event: event, tracking_number: params[:tracking_number])

    if previous_state == updated_order.status
      render json: { error: "Transition not allowed" }, status: :unprocessable_entity
    else
      render json: updated_order, status: :ok
    end
  end

  def order_params
    params.require(:order).permit(:total_amount)
  end

  def find_order
    Order.find(params[:id])
  end

end
