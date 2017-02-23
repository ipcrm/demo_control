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
    java_home      => '/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.121-0.b13.el7_3.x86_64/jre/',
  }

  firewall { '100 allow connections to wildfly':
    proto  => 'tcp',
    dport  => '8080',
    action => 'accept',
  }

}
