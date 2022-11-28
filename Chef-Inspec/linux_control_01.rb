describe file('/tmp') do
  it { should be_directory }
end

describe file('/app') do
  it { should be_exists }
end

describe file('/tmp/powerlog') do
  it { should be_directory }
end