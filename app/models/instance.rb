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
  after_create :create_aws_instance

  private

  def create_aws_instance
    # TODO
  end
end
