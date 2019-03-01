require 'test_helper'

class InstancesControllerTest < ActionDispatch::IntegrationTest
  test 'should create instance' do
    assert_difference('Instance.count') do
      post instances_url, params: { access_key_id: access_key_id,
                                    secret_access_key: secret_access_key }
    end
  end
end
