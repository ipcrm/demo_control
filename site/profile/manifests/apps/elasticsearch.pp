class profile::apps::elasticsearch {
  class { '::elasticsearch':
    java_install => true,
    manage_repo  => true,
    repo_version => '2.x',
    config       => {
      'network.host' => '0.0.0.0',
    },
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
