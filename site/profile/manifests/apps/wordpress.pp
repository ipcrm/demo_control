class profile::apps::wordpress (
  $listen_port = 80,
  $enable_ssl  = false,
  $docroot     = '/var/www/html',
  $manage_db   = true
){

  if $manage_db == true {
    $_create_db      = true
    $_create_db_user = true
  }else{
    $_create_db      = false
    $_create_db_user = false
  }

  case $enable_ssl {
    true: {
      file{"/etc/ssl/${::fqdn}.cert":
        ensure => present,
        mode   => '0644',
        owner  => $::apache::user,
        group  => $::apache::group,
        source => "${::settings::ssldir}/certs/${::fqdn}.pem",
      }

      file{"/etc/ssl/${::fqdn}.key":
        ensure => present,
        mode   => '0644',
        owner  => $::apache::user,
        group  => $::apache::group,
        source => "${::settings::ssldir}/private_keys/${::fqdn}.pem",
      }

      apache::vhost { "${::fqdn}-ssl":
        priority      => '10',
        vhost_name    => '*',
        port          => $listen_port,
        docroot       => $docroot,
        default_vhost => false,
        ssl           => true,
        ssl_cert      => "/etc/ssl/${::fqdn}.cert",
        ssl_key       => "/etc/ssl/${::fqdn}.key",
      }
    }
    default: {
      apache::vhost { $::fqdn:
        priority   => '10',
        vhost_name => $::fqdn,
        port       => $listen_port,
        docroot    => $docroot,
      }
    }
  }

  class { '::wordpress':
    install_dir    => $docroot,
    create_db      => $_create_db,
    create_db_user => $_create_db_user,
  }

  Apache::Vhost <||> -> Class['::wordpress']
}
