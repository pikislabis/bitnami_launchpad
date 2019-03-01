class Instance < ApplicationRecord
  attr_encrypted :access_key_id, key: ENV['ENCRYPTION_KEY']
  attr_encrypted :secret_access_key, key: ENV['ENCRYPTION_KEY']

  # ==========================================================
  # Validations
  # ==========================================================
  validates :access_key_id, :secret_access_key, presence: true

  # ==========================================================
  # Callbacks
  # ==========================================================
  after_initialize :assign_instance_status
  after_create :create_aws_instance

  private

  def assign_instance_status
    self.instance_status ||= 'pending'
  end

  def create_aws_instance
    CreateAwsInstanceWorker.perform_async(id) if id
  end
end
