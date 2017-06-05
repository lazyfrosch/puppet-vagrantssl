require 'spec_helper'

describe 'vagrantssl' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { should compile.with_all_deps }

      it { should contain_class('vagrantssl') }

      it do
        should contain_exec('puppet ca create')
          .with_command(/list -a/)
          .with_creates(Puppet.settings[:ssldir] + '/ca/ca_crt.pem')
          .with_path(%r{/opt/puppetlabs/puppet/bin:.*/usr/bin})
      end

      it do
        should contain_exec('puppet cert generate')
          .with_command(/generate 'foo.example.com'/)
          .with_creates(Puppet.settings[:ssldir] + '/certs/foo.example.com.pem')
          .with_path(%r{/opt/puppetlabs/puppet/bin:.*/usr/bin})
      end

      it do
        should contain_file('puppet cached crl')
          .with_path(Puppet.settings[:ssldir] + '/crl.pem')
          .with_source(Puppet.settings[:ssldir] + '/ca/ca_crl.pem')
      end
    end
  end
end
