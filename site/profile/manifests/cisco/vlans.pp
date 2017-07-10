# Claprofile::cisco::vlans
#
#
class profile::cisco::vlans {

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
