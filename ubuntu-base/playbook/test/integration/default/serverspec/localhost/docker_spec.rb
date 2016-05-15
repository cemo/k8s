require 'serverspec'
set :backend, :exec

describe command('docker -v') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /1.1/ }
end

describe group('docker') do
  it { should exist }
end

describe user('ubuntu') do
  it { should belong_to_group 'docker' }
end
