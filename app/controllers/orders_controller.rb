class OrdersController < ApplicationController
  rescue_from AASM::InvalidTransition, with: :handle_invalid_transition
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

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

  def confirm
    transition(:confirm)
  end

  def ship
    transition(:ship)
  end

  def deliver
    transition(:deliver)
  end

  def cancel
    transition(:cancel)
  end

  private

  def transition(event)   #maintainable
    order = find_order
    Orders::TransitionService.call(order: order, event: event)
    render json: order
  end

  def order_params
    params.require(:order).permit(:total)
  end

  def find_order
    Order.find(params[:id])
  end

  def handle_invalid_transition(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def handle_not_found
    render json: { error: "Order not found" }, status: :not_found
  end
end
