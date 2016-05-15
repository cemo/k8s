require 'serverspec'
set :backend, :exec

describe command('consul -v') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /0.6/ }
end
