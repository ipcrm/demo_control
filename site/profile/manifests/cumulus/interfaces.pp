class profile::cumulus::interfaces (
  $int_config = {}
){

  if !empty($int_config) {

    file {'/etc/network/interfaces':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('profile/cumulus/interfaces.erb'),
    }

#    service {'networking':
#      ensure    => running,
#      enable    => true,
#      subscribe => File['/etc/network/interfaces'],
#    }

  }


}
