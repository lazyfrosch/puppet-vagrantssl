# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_ROOT = File.dirname(__FILE__)
MODULE       = 'vagrantssl'
MODULE_PATH  = VAGRANT_ROOT + '/spec/fixtures/modules/' + MODULE
MANIFEST     = VAGRANT_ROOT + '/spec/fixtures/manifests/site.pp'

unless File.exists?(MODULE_PATH)
  puts "Running 'rake spec_prep' for you..."
  raise Exception, 'Could not prepare the spec environment!' unless system("cd #{VAGRANT_ROOT} && rake spec_prep")
end

if File.size(MANIFEST) == 0
  File.open(MANIFEST, 'a') do |file|
    file.write <<-EOF
      node 'ssl.vagrant.local' {
        include ::#{MODULE}
      }
    EOF
  end
end

Vagrant.configure(2) do |config|
  config.vm.box      = 'centos/7'
  config.vm.hostname = 'ssl.vagrant.local'

  ca_dir = "#{VAGRANT_ROOT}/.ca"
  Dir.mkdir(ca_dir) unless File.exists?(ca_dir)

  config.vm.synced_folder '.', '/vagrant', type: 'virtualbox' # avoid rsync
  config.vm.synced_folder ca_dir, '/etc/puppetlabs/puppet/ssl', type: 'virtualbox' # avoid rsync

  config.vm.provision 'shell' do |shell|
    shell.path = 'vagrant/shell_provision.sh'
  end

  config.vm.provision 'puppet' do |puppet|
    puppet.environment      = 'spec/fixtures'
    puppet.environment_path = '.'
  end
end
