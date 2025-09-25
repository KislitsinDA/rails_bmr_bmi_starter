class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_unprocessable(e)
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found(e)
    render json: { error: e.message }, status: :not_found
  end
end
