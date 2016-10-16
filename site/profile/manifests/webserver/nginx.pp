class profile::webserver::nginx {

  class { 'php':
    composer => false,
  }

  class { 'nginx': }

  Class['php'] -> Class['nginx']

}
