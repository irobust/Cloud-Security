describe aws_ec2_instances(aws_region: 'ap-southeast-1') do
    its('count') { should be <= 2 }
end

describe aws_ec2_instance('i-01a2349e94458a507') do
    it { should exist }
    it { should be_running }
    it { should_not have_roles }y
end

aws_ec2_instances.where(tags: /"tier"=>"web"/).instance_ids.each do |id|
    describe aws_ec2_instance(id) do
        its('role') { should eq "test-role" }
    end
end 

describe aws_ec2_instance(name: 'my-instance') do
    it { should exist }
end

describe aws_ec2_instance('i-090c29e4f4c165b74') do
    its('tags') { should include(key: 'Contact', value: 'Gilfoyle') }
end




