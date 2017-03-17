class profile::apps::jenkins (
  $version = '2.32.3',
){

  class { '::jenkins':
    version            => $version,
    configure_firewall => true,
  }

}
