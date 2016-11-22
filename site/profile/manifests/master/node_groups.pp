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
    rule                 => ['and', ['not', ['~', ['fact', 'role'], '\w+']], ['not', ['=', ['fact', 'clientcert'], 'master.demo.lan']]],
  }

  node_group { 'role::webserver_nginx':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    classes              => {
      'role::webserver_nginx' => {},
    },
    rule                 => ['and', ['=', ['fact', 'role'], 'webserver_nginx']],
  }

  node_group { 'role::database_mysql':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'role'], 'database_mysql']],
    classes              => {
      'role::database_mysql' => {},
    },
  }

  node_group { 'role::rgbank_standalone':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    classes              => {
      'role::rgbank_standalone' => {},
    },
  }

  node_group { 'role::cmlx_spine':
    ensure               => 'present',
    classes              => {'role::cmlx_spine' => {}},
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'role'], 'cmlx_spine']],
  }

  node_group { 'role::cmlx_leaf':
    ensure               => 'present',
    classes              => {'role::cmlx_leaf' => {}},
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'role'], 'cmlx_leaf']],
  }

}
