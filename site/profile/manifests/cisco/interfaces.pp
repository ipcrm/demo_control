class profile::cisco::interfaces {
  # lint:ignore:quoted_booleans
  [3,4,5,6].each |$i| {
    cisco_interface { "ethernet1/${i}":
      ensure          => 'present',
      description     => "Eth1/${i} Example Int Config",
      access_vlan     => '2',
      duplex          => 'auto',
      mtu             => '1500',
      negotiate_auto  => 'true',
      shutdown        => 'false',
      speed           => 'auto',
      stp_bpdufilter  => 'enable',
      stp_bpduguard   => 'enable',
      switchport_mode => 'access',
      switchport_vtp  => 'false',
    }
  }
  # lint:endignore
}
