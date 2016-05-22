require 'serverspec'
set :backend, :exec

describe service('go-server') do
  it { should be_enabled }
  it { should be_running }
end

describe service('go-agent') do
  it { should be_enabled }
  it { should be_running }
end
