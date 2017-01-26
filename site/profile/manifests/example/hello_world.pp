class profile::example::hello_world (
  $war_files       = ['helloworld.war'],
  $war_source      = 'http://master.demo.lan/artifacts',
  $tomcat_source   = 'https://www.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz',
  $manage_firewall = true
){

  package {'haveged':
    ensure  => present,
  }

  java::oracle { 'jdk8' :
    ensure  => 'present',
    version => '8',
    java_se => 'jdk',
  }

  class { '::tomcat':
    install_from  => 'archive',
    version       => '8.0.15',
    catalina_home => '/opt/tomcat',
  }

  tomcat::instance { 'tomcat-first':
    server_control_port => 8005,
    http_port           => 8080,
    manage_firewall     => true,
  }

  tomcat::instance { 'tomcat-first':
    server_control_port => 8006,
    ajp_port            => 8109,
    http_port           => 8081,
    manage_firewall     => true,
  }

  $war_files.each |$war_file| {

    File {
      require => [
        Tomcat::Instance['tomcat-first'],
        Tomcat::Instance['tomcat-second'],
      ],
    }

    file {"/opt/tomcat/tomcat-first/webapps/${war_file}":
      ensure => present,
      owner  => tomcat,
      group  => tomcat,
      mode   => '0755',
      source => "${war_source}/${war_file}",
    }

    file {"/opt/tomcat/tomcat-second/webapps/${war_file}":
      ensure => present,
      owner  => tomcat,
      group  => tomcat,
      mode   => '0755',
      source => "${war_source}/${war_file}",
    }

  }

}
