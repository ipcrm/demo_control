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

  node_group { 'roles':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => [],
    classes              => {},
  }


  Node_group {
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'roles',
  }

  node_group { 'generalserver':
    rule => [
      'and', [
        'not', [
          '=', ['fact', 'osfamily'], 'cisco-wrlinux']
      ], [
        'not', [
          '~', ['fact', 'role'], '\w+']
      ], [
        'not', ['=', ['fact', 'clientcert'], 'master.demo.lan']
        ]
    ],
  }

  node_group { 'webserver_nginx':
    classes => {
      'role::webserver_nginx' => {},
    },
    rule    => ['and', ['=', ['fact', 'role'], 'webserver_nginx']],
  }

  node_group { 'master':
    rule    => ['and', ['=', ['fact', 'clientcert'], $::clientcert]],
    classes => {
      'role::master' => {},
    },
  }

  node_group { 'database_mysql':
    rule    => ['and', ['=', ['fact', 'role'], 'database_mysql']],
    classes => {
      'role::database_mysql' => {},
    },
  }

  node_group { 'cumulus':
    classes              => {'role::cumulus' => {}},
  }

  node_group { 'apps':
    classes              => {},
  }

  node_group { 'rgbank_standalone':
    parent  => 'apps',
    classes => {
      'role::rgbank_standalone' => {},
    },
  }

  node_group { 'jenkins_master':
    parent  => 'apps',
    classes => {
      'role::jenkins_master' => {},
    },
  }


}
