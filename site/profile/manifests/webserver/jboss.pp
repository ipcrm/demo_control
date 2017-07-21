class profile::webserver::jboss (
  $version = '8.0.0',
  $source = "http://download.jboss.org/wildfly/${version}.Final/wildfly-${version}.Final.tar.gz"
) {

  class { '::java':
    version => latest,
  }

  class { '::wildfly':
    install_source => $source,
    version        => $version,
    require        => Class['java'],
    java_home      => '/usr/lib/jvm/java/jre/',
    properties     => {
      'jboss.bind.address'            => '0.0.0.0',
      'jboss.bind.address.management' => '0.0.0.0'
    },
    mgmt_user      => {
      username => 'admin',
      password => 'admin',
    },
  }

  firewall { '100 allow connections to wildfly':
    proto  => 'tcp',
    dport  => '8080',
    action => 'accept',
  }

}
