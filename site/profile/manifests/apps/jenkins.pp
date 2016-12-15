class profile::apps::jenkins (
  $version = '2.19.4',
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
