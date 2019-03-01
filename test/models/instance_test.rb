require 'test_helper'

class InstanceTest < ActiveSupport::TestCase
  test 'valid instance' do
    instance = Instance.new(access_key_id: access_key_id, secret_access_key: secret_access_key)
    assert instance.valid?
  end

  test 'invalid without credentials' do
    instance = Instance.new
    refute instance.valid?
    assert_not_nil instance.errors[:access_key_id]
    assert_not_nil instance.errors[:secret_access_key]
  end
end
