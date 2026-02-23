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

end
