class profile::apps::jenkins (
  $version = '1.642.4',
){

  class { '::jenkins':
    version            => $version,
    configure_firewall => true,
  }

}
