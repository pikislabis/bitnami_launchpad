class InstancesController < ApplicationController

  # POST /instances
  def create
    instance = Instance.new(instance_params)
    if instance.save
      render json: instance, status: :ok
    else
      render json: { error: { code: 422, message: instance.errors } }, status: :unprocessable_entity
    end
  end

  private

  def instance_params
    params.permit(:access_key_id, :secret_access_key)
  end
end
