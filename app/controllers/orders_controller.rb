class OrdersController < ApplicationController
  rescue_from AASM::InvalidTransition, with: :handle_invalid_transition
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  def ship
    order = find_order
    Orders::TransitionService.call(order: order, event: :ship)
    render json: order
  end

  private

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
