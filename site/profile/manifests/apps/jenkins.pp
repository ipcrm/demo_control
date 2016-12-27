class profile::apps::jenkins (
  $version = '1.642.2',
){

  class { '::jenkins':
    version            => $version,
    configure_firewall => true,
  }

}
