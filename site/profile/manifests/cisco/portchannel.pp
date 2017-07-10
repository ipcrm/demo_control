class profile::cisco::portchannel {

  Class['profile::cisco::portchannel'] ~> Exec['cisco save config']

  # Source https://github.com/cisco/cisco-network-puppet-module/blob/master/examples/cisco/demo_portchannel.pp
  # lint:ignore:quoted_booleans
  cisco_portchannel_global { 'default':
    bundle_hash   => 'ip',
    bundle_select => 'src-dst',
    concatenation => 'true',
    resilient     => 'false',
    rotate        => '4',
    symmetry      => 'false',
  }

  cisco_interface_portchannel {'port-channel100':
    ensure                    => 'present',
    lacp_graceful_convergence => 'false',
    lacp_max_bundle           => 10,
    lacp_min_links            => 2,
    lacp_suspend_individual   => 'false',
    port_hash_distribution    => 'adaptive',
    port_load_defer           => 'true',
  }
  # lint:endignore

  cisco_interface { 'port-channel100':
    switchport_mode               => trunk,
    switchport_trunk_allowed_vlan => '2,3',
    switchport_trunk_native_vlan  => '2',
  }

  [1,2].each |$i| {
    cisco_interface_channel_group { "Ethernet1/${i}":
      channel_group => 100,
    }
  }


}
