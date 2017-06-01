class profile::base(
  Boolean $orch_agent = false,
  String  $package_version = '1.8.2',
){

  host{$::fqdn:
    ensure       => present,
    ip           => $::ipaddress,
    host_aliases => [$::hostname],
  }

  contain ::profile::base::ntp
  contain ::profile::base::motd
  contain ::profile::base::ssh
  contain ::profile::base::services
  contain ::profile::base::pkgs
  contain ::profile::base::reboots
  contain ::profile::base::dns
  contain ::profile::base::users_groups
  contain ::profile::base::security

  if $::facts['kernel'] != 'windows' {
    contain ::profile::base::sudo
  }

  if $::facts['kernel'] == 'windows' {

    $ace_list = {
      'guests'     => {
        secprincipal => 'BUILTIN\Guests',
        inheritance  => '"ContainerInherit","ObjectInherit"',
        propagation  => 'None',
        objaccess    => '"FullControl"',
        objtype      => 'Allow',
        remove_ace   => false,
      },
      'users'     => {
        secprincipal => 'BUILTIN\Users',
        inheritance  => '"ContainerInherit","ObjectInherit"',
        propagation  => 'None',
        objaccess    => '"FullControl"',
        objtype      => 'Allow',
        remove_ace   => false,
      },
      'admin' => {
        secprincipal => 'GP-WIN-1\Admin',
        inheritance  => '"ContainerInherit","ObjectInherit"',
        propagation  => 'None',
        objaccess    => '"FullControl"',
        objtype      => 'Allow',
        remove_ace   => true,
      },
    }

    registry_acl {'hklm:SOFTWARE\Bob':
      ace_hash => $ace_list,
    }



    $ace_list_test = {
      'admins' => {
        secprincipal => 'BUILTIN\Administrators',
        inheritance  => '"ContainerInherit","ObjectInherit"',
        propagation  => 'None',
        objaccess    => '"FullControl"',
        objtype      => 'Allow',
        remove_ace   => false,
      },
      'admin' => {
        secprincipal => 'GP-WIN-1\Admin',
        inheritance  => '"ContainerInherit","ObjectInherit"',
        propagation  => 'None',
        objaccess    => '"FullControl"',
        objtype      => 'Allow',
        remove_ace   => false,
      },
    }

    registry_acl {'hklm:SOFTWARE\Bob\test':
      ace_hash            => $ace_list_test,
      purge               => true,
      inherit_from_parent => false,
    }
  }

  if $orch_agent == true { contain ::profile::base::orch_agent }

  if $::fqdn != $::puppet_master_server {
    class {'::puppet_agent':
        package_version => $package_version,
    }
  }

}
