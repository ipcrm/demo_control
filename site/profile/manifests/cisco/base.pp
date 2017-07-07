class profile::cisco::base {
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

  # VTP
  cisco_vtp {'default':
    ensure   => present,
    name     => 'default',
    domain   => 'examplevtp',
    password => 'example',
    version  => 'default',
  }

}
