# == Class: vagrantssl::letsencrypt
#
# Simulates the locations of original letsencrypt certificates
#
#
class vagrantssl::letsencrypt {
  include ::vagrantssl

  $_letsencrypt = '/etc/letsencrypt'
  $_letsencrypt_hostpath = "${_letsencrypt}/live/${vagrantssl::certname}"

  File {
    owner => 'root',
    group => 'root',
    mode  => '0600',
  }

  file {
    "${_letsencrypt}":
      ensure => directory;
    "${_letsencrypt}/vagrantssl":
      ensure => directory;
    "${_letsencrypt}/live":
      ensure => directory;
    "${_letsencrypt_hostpath}":
      ensure => directory;
  }

  file {
    "${_letsencrypt_hostpath}/cert.pem":
      ensure => link,
      target => "${::vagrantssl::ssldir}/certs/${vagrantssl::certname}.pem";
    "${_letsencrypt_hostpath}/chain.pem":
      ensure => link,
      target => "${::vagrantssl::ssldir}/certs/ca.pem";
    "${_letsencrypt_hostpath}/fullchain.pem":
      ensure => link,
      target => "${_letsencrypt}/vagrantssl/fullchain.pem";
    "${_letsencrypt_hostpath}/privkey.pem":
      ensure => link,
      target => "${::vagrantssl::ssldir}/private_keys/${vagrantssl::certname}.pem";
  }

  concat { 'vagrantssl letsencrypt fullchain':
    path => "${_letsencrypt}/vagrantssl/fullchain.pem",
  }

  concat::fragment {
    'vagrantssl letsencrypt fullchain cert':
      target => 'vagrantssl letsencrypt fullchain',
      order  => '00',
      source => "${::vagrantssl::ssldir}/certs/${vagrantssl::certname}.pem";
    'vagrantssl letsencrypt fullchain ca':
      target => 'vagrantssl letsencrypt fullchain',
      order  => '10',
      source => "${::vagrantssl::ssldir}/certs/ca.pem";
  }
}
