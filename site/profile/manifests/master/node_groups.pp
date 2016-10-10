class profile::master::node_groups {

  package { 'puppetclassify':
    ensure   => present,
    provider => puppet_gem,
  }

  Node_group {
    require => Package['puppetclassify'],
  }

  node_group { 'role::master':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'trusted.certname'], $::clientcert]],
    classes              => {
      'role::master' => {},
    },
  }

  node_group { 'role::generalserver':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'trusted.extensions.pp_role'], 'generalserver']],
    classes              => {
      'role::generalserver' => {},
    },
  }

}
