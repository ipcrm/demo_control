class profile::example::hello_world (
  $war_files       = ['helloworld.war'],
  $war_source      = 'http://master.demo.lan/artifacts',
  $tomcat_source   = 'https://www.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz',
  $listen_port     = '8080',
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

  tomcat::install { '/opt/tomcat':
      source_url => $tomcat_source,
  } ->

  tomcat::instance { 'default':
      catalina_home  => '/opt/tomcat',
      manage_service => false,
      java_home      => '/usr/java/latest/jre',
  } ->

  tomcat::config::server { 'default':
      catalina_base => '/opt/tomcat',
      address       => '0.0.0.0',
      port          => $listen_port,
  } ->

  tomcat::service {'default':
    catalina_home  => '/opt/tomcat',
    catalina_base  => '/opt/tomcat',
    service_name   => 'tomcat-default',
    service_enable => true,
    java_home      => '/usr/java/latest/jre',
  } ->

  tomcat::config::server::host {'localhost':
    catalina_base         => '/opt/tomcat',
    additional_attributes => {
      # lint:ignore:quoted_booleans
      'unpackWARs' => 'true',
      # lint:endignore
    },
    app_base              => 'webapps',
  }

  $war_files.each |$war_file| {

    tomcat::war { $war_file:
      catalina_base => '/opt/tomcat',
      war_source    => "${war_source}/${war_file}",
    }

  }

  if $manage_firewall == true {

    firewall { "${listen_port} allow tomcat access":
      dport  => [$listen_port],
      proto  => tcp,
      action => accept,
    }

  }

}
