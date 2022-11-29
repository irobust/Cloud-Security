describe aws_ec2_instances(aws_region: 'ap-southeast-1') do
    its('count') { should be <= 2 }
end


