class profile::example::hello_world (
  $war_files       = ['helloworld.war'],
  $war_source      = 'http://master.demo.lan/artifacts',
  $tomcat_source   = 'https://www.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz',
  $manage_firewall = true,
  $java_opts       = ['-server',
                      '-Djava.net.preferIPv4Stack=true',
                      '-Djava.net.preferIPv4Addresses',
                      '-Djava.security.egd=file:/dev/./urandom',
  ]
){

  java::oracle { 'jdk8' :
    ensure  => 'present',
    version => '8',
    java_se => 'jdk',
  }

#  class { '::tomcat':
#    install_from         => 'archive',
#    version              => '8.0.15',
#    catalina_home        => '/opt/tomcat',
#    java_opts            => $java_opts,
#    manage_firewall      => $manage_firewall,
#    create_default_admin => true,
#  }

  tomcat::instance { 'instance2':
    version              => '8.0.18',
    catalina_home        => '/opt/tomcat2',
    java_opts            => $java_opts,
    server_control_port  => 8006,
    http_port            => 8081,
    ajp_port             => 8109,
    manage_firewall      => $manage_firewall,
    create_default_admin => true,
  }

  $war_files.each |$war_file| {

    file {"/opt/tomcat/webapps/${war_file}":
      ensure => present,
      owner  => tomcat,
      group  => tomcat,
      mode   => '0755',
      source => "${war_source}/${war_file}",
    }

    file {"/opt/tomcat2/webapps/${war_file}":
      ensure => present,
      owner  => tomcat,
      group  => tomcat,
      mode   => '0755',
      source => "${war_source}/${war_file}",
    }

  }

}
