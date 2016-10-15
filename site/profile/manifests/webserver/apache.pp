class profile::webserver::apache (
  Boolean $default_vhost   = false,
  Boolean $manage_firewall = true,
  Array $firewall_ports    = [80,443],
  String $ssl_cipher       = 'HIGH:MEDIUM:!aNULL:!MD5:!RC4'
){

  class { '::apache':
    default_vhost => $default_vhost,
  }

  class { '::apache::mod::ssl':
    ssl_cipher => $ssl_cipher,
  }

  class { '::apache::mod::php': }

  if $manage_firewall == true {

    $firewall_ports.each |$p| {
      firewall { "${p} allow apache access":
        dport  => [$p],
        proto  => tcp,
        action => accept,
      }
    }

  }

}
