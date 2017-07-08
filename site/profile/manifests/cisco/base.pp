class profile::cisco::base {
  # Setup
  include ::ciscopuppet::install

  # Setup Crontab PAM Access
  file {'/etc/pam.d/crond':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => '
    auth       sufficient pam_rootok.so
    auth       required   pam_env.so
    account    required   pam_access.so
    session    required   pam_limits.so
    session    required   pam_loginuid.so
    ',
    before  => Class['puppet_enterprise::profile::mcollective::agent'],
  }

  # Update systemd init processes
  file {'/usr/lib/systemd/system/mcollective.service':
    ensure  => present,
    source  => 'puppet:///modules/profile/cisco/mcollective.service',
    notify  => Service['mcollective'],
    require => Class['puppet_enterprise::profile::mcollective::agent'],
  }

  file {'/usr/lib/systemd/system/pxp-agent.service':
    ensure  => present,
    source  => 'puppet:///modules/profile/cisco/pxp-agent.service',
    notify  => Service['pxp-agent'],
    require => Class['puppet_enterprise::profile::mcollective::agent'],
  }

  # NTP
  ntp_config{'default':
    source_interface => 'mgmt0',
  }
  ntp_server{'24.56.178.140':
    ensure => present,
  }

  # Configure some VLANs
  cisco_vlan { '2':
    ensure    => 'present',
    shutdown  => false,
    state     => 'active',
    vlan_name => 'vlan2',
  }
  cisco_vlan { '3':
    ensure    => 'present',
    shutdown  => false,
    state     => 'active',
    vlan_name => 'vlan3',
  }

}
