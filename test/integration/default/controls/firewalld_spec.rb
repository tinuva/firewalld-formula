# frozen_string_literal: true

describe package('firewalld') do
  it { should be_installed }
end

describe service('firewalld') do
  it { should be_enabled }
  it { should be_running }
end

describe service('iptables') do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe service('ip6tables') do
  it { should_not be_enabled }
  it { should_not be_running }
end
