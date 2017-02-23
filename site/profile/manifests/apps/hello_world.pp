class profile::apps::hello_world (
  $war_files       = ['helloworld.war'],
  $war_source      = 'http://master.demo.lan/artifacts',
){

  contain ::profile::webserver::wildfly

  $war_files.each |$w| {

    wildfly::deployment { $w:
      source => "${war_source}/${w}",
    }

  }


}
