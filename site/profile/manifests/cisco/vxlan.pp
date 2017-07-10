class profile::cisco::vxlan {

  Class['profile::cisco::vxlan'] ~> Exec['cisco save config']

  cisco_vxlan_vtep { 'nve1':
    ensure            => present,
    description       => 'Configured by puppet',
    host_reachability => 'evpn',
    shutdown          => false,
    source_interface  => 'loopback1',
  }

  cisco_vxlan_vtep_vni {'nve1 10000':
    ensure              => present,
    assoc_vrf           => false,
    ingress_replication => 'static',
    peer_list           => ['4.4.4.4', '5.5.5.5'],
  }
}
