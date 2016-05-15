require 'serverspec'
set :backend, :exec

describe command('aws --version') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match /aws-cli\/1.10/ }
end
