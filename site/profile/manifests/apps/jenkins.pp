class profile::apps::jenkins (
  $version = '2.19.4',
){

  class { '::jenkins':
    version            => $version,
    configure_firewall => true,
  }

}
