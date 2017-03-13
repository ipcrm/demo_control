class profile::base(
  Boolean $orch_agent = false,
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
  contain ::profile::base::sudo

  if $orch_agent == true { contain ::profile::base::orch_agent }

  if $::fqdn != $::puppet_master_server {
    class {'::puppet_agent':
        package_version => '1.8.2',
    }
  }

}
