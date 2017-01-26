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

  tomcat::install { '/opt/tomcat':
      source_url => $tomcat_source,
  } ->

  tomcat::instance { 'tomcat-first':
    catalina_home => '/opt/tomcat',
    catalina_base => '/opt/tomcat/first',
  }

  tomcat::instance { 'tomcat-second':
    catalina_home => '/opt/tomcat',
    catalina_base => '/opt/tomcat/second',
  }

  tomcat::config::server { 'tomcat-second':
    catalina_base => '/opt/tomcat/second',
    port          => '9090',
  }

  $war_files.each |$war_file| {

    tomcat::war { $war_file:
      catalina_base => '/opt/tomcat/first',
      war_source    => "${war_source}/${war_file}",
    }

    tomcat::war { $war_file:
      catalina_base => '/opt/tomcat/second',
      war_source    => "${war_source}/${war_file}",
    }

  }

  if $manage_firewall == true {

    firewall { 'allow tomcat access':
      dport  => [8080,9090],
      proto  => tcp,
      action => accept,
    }

  }

}
