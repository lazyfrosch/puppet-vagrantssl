require 'spec_helper'

describe 'vagrantssl::letsencrypt' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { should compile.with_all_deps }

      it { should contain_class('vagrantssl::letsencrypt') }
      it { should contain_class('vagrantssl') }

      it { should contain_file('/etc/letsencrypt').with_ensure('directory') }
      it { should contain_file('/etc/letsencrypt/vagrantssl').with_ensure('directory') }
      it { should contain_file('/etc/letsencrypt/live').with_ensure('directory') }
      it { should contain_file('/etc/letsencrypt/live/foo.example.com').with_ensure('directory') }

      base_path = '/etc/letsencrypt/live/foo.example.com'
      it do
        should contain_file(base_path + '/cert.pem')
          .with_ensure('link')
          .with_target(Puppet.settings[:ssldir] + '/certs/foo.example.com.pem')
      end
      it do
        should contain_file(base_path + '/privkey.pem')
          .with_ensure('link')
          .with_target(Puppet.settings[:ssldir] + '/private_keys/foo.example.com.pem')
      end
      it do
        should contain_file(base_path + '/chain.pem')
          .with_ensure('link')
          .with_target(Puppet.settings[:ssldir] + '/certs/ca.pem')
      end
      it do
        should contain_file(base_path + '/fullchain.pem')
          .with_ensure('link')
          .with_target('/etc/letsencrypt/vagrantssl/fullchain.pem')
      end

      it do
        should contain_concat('vagrantssl letsencrypt fullchain')
          .with_path('/etc/letsencrypt/vagrantssl/fullchain.pem')
      end
      it do
        should contain_concat__fragment('vagrantssl letsencrypt fullchain cert')
          .with_source(Puppet.settings[:ssldir] + '/certs/foo.example.com.pem')
      end
      it do
        should contain_concat__fragment('vagrantssl letsencrypt fullchain ca')
          .with_source(Puppet.settings[:ssldir] + '/certs/ca.pem')
      end
    end
  end
end
