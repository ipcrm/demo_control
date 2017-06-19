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

  class{'::profile::base::orch_agent':
    ensure => $orch_agent,
  }

  if $::fqdn != $::puppet_master_server {
    class {'::puppet_agent':
        package_version => $package_version,
    }
  }

}
