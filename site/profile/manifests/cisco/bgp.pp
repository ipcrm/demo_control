class profile::cisco::bgp {

  Class['profile::cisco::bgp'] ~> Exec['cisco save config']

  cisco_command_config { 'features':
    command => "
      feature bgp
    "
  }

  cisco_bgp { '65001 default':
    ensure      => 'present',
    maxas_limit => '8',
    router_id   => '192.0.2.4',
    shutdown    => false,
    require     => Cisco_command_config['features'],
  }

  cisco_bgp_neighbor { '65001 default 192.0.3.1':
    ensure    => 'present',
    remote_as => '65004',
    require   => Cisco_bgp['65001 default'],
  }
}
