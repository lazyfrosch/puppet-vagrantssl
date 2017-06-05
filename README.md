Puppet SSL in Vagrant
=====================

For testing purposes its often very nice to have a simple CA in place.

Puppet can do that, but when you use it in apply-mode for Vagrant, there are not certificates.

## How to use

Update your `Vagrantfile` to include a new synced_folder.
You will need a live folder like the `virtualbox` or `nfs` type.

```ruby
    config.vm.synced_folder 'ssl', '/var/lib/puppet/ssl', :type => 'virtualbox'
    # or
    config.vm.synced_folder 'ssl', '/etc/puppet/ssl', :type => 'virtualbox'
````

You should also add the folder `.gitignore` in your Vagrant environment:

    /ssl

When you then include the class:

    include ::vagrantssl
    
A SSL CA is created, and a certificate/key pair for every vagrant node.

## License

    Copyright (C) 2015-2017 Markus Frosch <markus@lazyfrosch.de>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
