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
  }


  Node_group {
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'roles',
  }

  node_group { 'role::master':
    parent  => 'All Nodes',
    rule    => ['and', ['=', ['fact', 'clientcert'], $::clientcert]],
    classes => {
      'role::master' => {},
    },
  }


  node_group { 'generalserver':
    rule    => [
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
    classes => { 'role::generalserver' => {}, },
  }

  node_group { 'webserver_nginx':
    classes => { 'role::webserver_nginx' => {}, },
    rule    => ['or',
      ['=', ['fact', 'role'], 'webserver_nginx'],
      ['=', ['fact', 'role'], 'rgbank']
    ],
  }

  node_group { 'webserver_apache':
    classes => { 'role::webserver_apache' => {}, },
    rule    => ['or',
      ['=', ['fact', 'role'], 'flask_puppet']
    ],
  }

  node_group { 'database_mysql':
    rule    => ['or',
      ['=', ['fact', 'role'], 'database_mysql'],
      ['=', ['fact', 'role'], 'rgbank']
    ],
    classes => {
      'role::database_mysql' => {},
    },
  }

  node_group { 'sqlserver':
    classes => {'role::sqlserver' => {}},
    rule    => ['or', ['=', ['fact', 'role'], 'sqlwebapp'], ['=', ['fact', 'role'], 'database_sqlserver']],
  }

  node_group { 'webserver_iis':
    classes => {'role::webserver_iis' => {}},
    rule    => ['or', ['=', ['fact', 'role'], 'sqlwebapp'], ['=', ['fact', 'role'], 'webserver_iis']],
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
    classes => { 'role::jenkins_master' => {}, },
    rule    => ['and', ['=', ['fact', 'role'], 'jenkins_master']],
  }

  node_group { 'elasticsearch':
    parent  => 'apps',
    classes => {'role::elasticsearch' => {}},
    rule    => ['or', ['=', 'name', 'elasticsearch.demo.lan']],
  }

  node_group { 'role::master_elasticsearch':
    parent  => 'All Nodes',
    classes => {'elk_report' => {'elkreport_config' => {'host' => 'elasticsearch.demo.lan'}}},
    rule    => ['or', ['=', 'name', 'master.demo.lan']],
  }


}
