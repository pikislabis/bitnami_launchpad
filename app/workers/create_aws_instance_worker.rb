class CreateAwsInstanceWorker
  include Sidekiq::Worker

  def perform(id)
    @instance = Instance.find(id)

    aws_instance = create_aws_instance

    ec2.client.wait_until(:instance_status_ok, instance_ids: [aws_instance.id]) do |w|
      w.max_attempts = 60
      w.delay = 5
    end

    aws_instance.reload

    @instance.update(
      aws_instance_id: aws_instance.id,
      public_ip_address: aws_instance.public_ip_address,
      instance_status: aws_instance.state.name
    )

  rescue StandardError => e
    @instance.update(instance_status: e.message)
  end

  private

  def ec2
    @ec2 ||= Aws::EC2::Resource.new(
      region: 'eu-west-1',
      credentials: credentials
    )
  end

  def credentials
    @credentials ||= Aws::Credentials.new(
      @instance.access_key_id,
      @instance.secret_access_key
    )
  end

  def create_aws_instance
    security_group = create_security_group

    ec2.create_instances(
      image_id: 'ami-0ac30b0c69f1ee39b',
      min_count: 1,
      max_count: 1,
      security_group_ids: [security_group.id]
    ).first
  end

  def create_security_group
    sg = ec2.create_security_group(
      group_name: 'ghost',
      description: 'Security Group For Ghost'
    )

    sg.authorize_ingress({
      group_name: 'ghost',
      ip_permissions: [{
        ip_protocol: 'tcp',
        from_port: 80,
        to_port: 80,
        ip_ranges: [{
          cidr_ip: '0.0.0.0/0'
        }]
      }]
    })

    sg
  end
end
