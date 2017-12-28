require 'serverspec'
set :backend, :exec

describe service('firewalld') do
  it { should be_running }
end
