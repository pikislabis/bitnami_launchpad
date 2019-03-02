class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: { message: 'The resource is not found' }, status: :not_found
  end
end
