class vagrantssl (
  $certname    = $::fqdn,
  $ssldir      = $::settings::ssldir,
  $user        = 'vagrant',
  $letsencrypt = true,
) {
  validate_string($user, $certname)
  validate_absolute_path($ssldir)

  Exec {
    path => "/opt/puppetlabs/puppet/bin:${::path}",
    user => 'root',
  }

  $puppet_cert = "puppet cert --ssldir='${ssldir}' --user='${user}'"

  exec { 'puppet ca create':
    command => "${puppet_cert} list -a",
    creates => "${ssldir}/ca/ca_crt.pem",
  }

  -> exec { 'puppet cert generate':
    command => "${puppet_cert} generate '${certname}'",
    creates => "${ssldir}/certs/${certname}.pem",
  }

  -> file { 'puppet cached crl':
    ensure => file,
    path   => "${ssldir}/crl.pem",
    source => "${ssldir}/ca/ca_crl.pem",
  }

  if $letsencrypt {
    contain ::vagrantssl::letsencrypt
    Exec['puppet cert generate'] -> Class['::vagrantssl::letsencrypt']
  }
}
