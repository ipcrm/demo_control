class profile::apps::jenkins (
  $version = '1.642.3',
){

  class { '::jenkins':
    version            => $version,
    configure_firewall => true,
      plugin_hash           => {
      swarm                 => {},
      greenballs            => {},
      git                   => {},
      git-client            => {},
      scm-api               => {},
      build-pipeline-plugin => {},
      parameterized-trigger => {},
      jquery                => {},
      ruby-runtime          => {},
      gitlab-plugin         => {},
    },
  }

}
