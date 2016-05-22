require 'serverspec'
set :backend, :exec

describe file('/etc/rc.local') do
  its(:sha256sum) { should eq 'a1ea04e2f5b48e0994280cf387db60dd58181258e93f1d1a1c09e6dbf8572e9d' }
end

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
