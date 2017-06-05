#!/bin/bash

set -e

if [ ! -e /var/initial_update ]; then
    echo "Running initial yum update"
    yum update -y
    date > /var/initial_update
fi

if [ `getenforce` = 'Enforcing' ]; then
    echo "Setting selinux to permissive"
    setenforce 0
fi

if grep -qP "^SELINUX=enforcing" /etc/selinux/config; then
    echo "Disabling selinux after reboot"
    sed -i 's/^\(SELINUX=\)enforcing/\1disabled/' /etc/selinux/config
fi

if systemctl is-active NetworkManager.service >/dev/null; then
    systemctl stop NetworkManager.service
    systemctl disable NetworkManager.service
fi

if [ ! -e /etc/yum.repos.d/puppetlabs-pc1.repo ]; then
    echo "Installing Puppet release..."
    yum install -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi

if [ ! -e /opt/puppetlabs/puppet/bin/puppet ]; then
    echo "Installing puppet-agent..."
    yum install -y puppet-agent
fi
