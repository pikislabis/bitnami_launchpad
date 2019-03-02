class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: {code: 404, message: 'The resource is not found' } }, status: :not_found
  end
end
