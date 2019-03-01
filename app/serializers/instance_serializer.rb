class InstanceSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :aws_instance_id,
    :instance_status,
    :public_ip_address
  )
end
