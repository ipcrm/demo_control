class profile::base::ntp (
  Array $servers  = ['0.us.pool.ntp.org','1.us.pool.ntp.org'],
){

  case $facts['os']['name'] {
    'Windows': {
      class { 'winntp':
          servers => $servers,
      }
    }

    default: {
      class{'::ntp':
        servers           => $servers,
        maxpoll           => 4,
        minpoll           => 4,
        iburst_enable     => true,
        tinker            => false,
        preferred_servers => $servers,
        restrict          => [],
      }
    }

  }


}
