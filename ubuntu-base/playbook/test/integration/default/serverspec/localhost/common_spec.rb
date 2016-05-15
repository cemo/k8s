require 'serverspec'
set :backend, :exec

describe package('zip') do
  it { should be_installed }
end

describe package('unzip') do
  it { should be_installed }
end

describe package('jq') do
  it { should be_installed }
end

describe package('ntp') do
  it { should be_installed }
end

describe service('ntp') do
  it { should be_enabled }
  it { should be_running }
end
