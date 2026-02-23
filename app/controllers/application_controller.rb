class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from AASM::InvalidTransition, with: :render_invalid_transition

  private

  def render_not_found(exception)
    render json: {
      error: {
        type: "not_found",
        message: exception.message
      }
    }, status: :not_found
  end

  def render_invalid_transition(exception)
    render json: {
      error: {
        type: "invalid_transition",
        message: exception.message
      }
    }, status: :unprocessable_entity
  end
end
