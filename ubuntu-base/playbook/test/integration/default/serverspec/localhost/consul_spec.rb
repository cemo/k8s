require 'serverspec'
set :backend, :exec

describe command('consul -v') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /0.6/ }
end

describe file('/etc/consul.d') do
  it { should be_directory }
end

describe file('/etc/init/consul.conf') do
  it { should exist }
end
