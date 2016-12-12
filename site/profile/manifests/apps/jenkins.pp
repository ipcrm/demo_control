class profile::apps::jenkins {

  class { '::jenkins':
    configure_firewall => true,
    plugin_hash        => {
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
