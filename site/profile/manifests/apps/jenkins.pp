class profile::apps::jenkins (
  $version = '2.32.3',
){

  java::oracle { 'jdk8' :
    ensure  => 'present',
    version => '8',
    java_se => 'jdk',
  }

  class { '::jenkins':
    version            => $version,
    configure_firewall => true,
    install_java       => false,
  }

}
