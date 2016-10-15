class profile::master::node_groups {

  package { 'puppetclassify':
    ensure   => present,
    provider => puppet_gem,
    notify   => Exec['refresh_classes'],
  }

  Node_group {
    require => Package['puppetclassify'],
  }

  exec{'refresh_classes':
    path        => $::path,
    command     => "/etc/puppetlabs/code/environments/${::environment}/scripts/refresh_classes.sh",
    refreshonly => true,
  }

  node_group { 'role::master':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'clientcert'], $::clientcert]],
    classes              => {
      'role::master' => {},
    },
  }
  node_group { 'role::generalserver':
    ensure               => 'present',
    classes              => {'role::generalserver' => {}},
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['not', ['~', ['fact', 'role'], '.+']], ['not', ['=', ['fact', 'clientcert'], 'master.demo.lan']]],
  }

}
