class profile::apps::elasticsearch {
  $config_hash = {
    'ES_HEAP_SIZE' => '3g',
    'ES_JAVA_OPTS' => '-Xms3g -Xmx3g',
  }


  class { '::elasticsearch':
    java_install  => true,
    manage_repo   => true,
    repo_version  => '2.x',
    config        => {
      'network.host' => '0.0.0.0',
    },
    init_defaults => $config_hash,
  }

  elasticsearch::instance { 'es-01': }

  class{'::kibana4':
    plugins => {
      'elastic/sense' => {
        ensure          => present,
        plugin_dest_dir => 'sense',
      },
    },
  }
}
