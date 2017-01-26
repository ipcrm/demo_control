class profile::example::hello_world (
  $war_files = ['helloworld.war'],
  $war_source = 'http://master.demo.lan/artifacts',
  $tomcat_source = 'https://www.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
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
  }

  tomcat::instance { 'default':
      catalina_home  => '/opt/tomcat',
      manage_service => false,
      java_home      => '/usr/java/latest/jre',
  }

  tomcat::config::server { 'default':
      catalina_base => '/opt/tomcat',
      address       => '0.0.0.0',
  }

  tomcat::service {'default':
    catalina_home  => '/opt/tomcat',
    catalina_base  => '/opt/tomcat',
    service_name   => 'tomcat-default',
    service_enable => true,
    java_home      => '/usr/java/latest/jre',
  }

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

    remote_file { $war_file:
      ensure => latest,
      path   => "/var/tmp/${war_file}",
      source => "${war_source}/${war_file}",
    }

    file { $war_file:
      ensure  => present,
      path    => "/opt/tomcat/webapps/${war_file}",
      source  => "/var/tmp/${war_file}",
      owner   => 'tomcat',
      group   => 'tomcat',
      require => Remote_file[$war_file],
    }

  }

}
