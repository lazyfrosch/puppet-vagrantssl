class vagrantssl {

  $_options = [
    '--cadir=/vagrant/.ca',
    '--user=vagrant',
  ]
  $__options = join($_options, ' ')

  # build local CA
  # local certifcate will be put in /var/lib/puppet/ssl automatically
  exec { 'puppet vagrant CA':
    command => "puppet cert ${__options} generate '${::fqdn}'",
    user    => 'root',
    path    => $::path,
    creates => "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
  }

  # copy CRL locally
  # what the Puppet agent does usually
  file { 'puppet cached crl':
    ensure => file,
    path   => '/var/lib/puppet/ssl/crl.pem',
    source => '/vagrant/.ca/ca_crl.pem',
    owner  => 'puppet',
    group  => 'puppet',
  }

}
