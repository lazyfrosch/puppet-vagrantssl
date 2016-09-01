class vagrantssl(
  $user     = 'vagrant',
  $ssldir   = $::settings::ssldir,
  $certname = $::fqdn,
) {
  validate_string($user, $certname)
  validate_absolute_path($ssldir)

  Exec {
    path => $::path,
    user => 'root',
  }

  $puppet_cert = "puppet cert --ssldir='${ssldir}' --user='${user}'"

  exec { 'puppet ca create':
    command => "${puppet_cert} list -a",
    creates => "${ssldir}/ca/ca_crt.pem",
  } ->

  exec { 'puppet ca generate':
    command => "${puppet_cert} generate '${certname}'",
    creates => "${ssldir}/certs/${certname}.pem",
  } ->

  file { 'puppet ca crl':
    ensure => file,
    path   => "${ssldir}/crl.pem",
    source => "${ssldir}/ca/ca_crl.pem",
  }
}
