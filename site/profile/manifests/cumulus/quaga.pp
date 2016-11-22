class profile::cumulus::quagga (
  String $router_id,
){

  file { '/etc/quagga/Quagga.conf':
    owner   => 'root',
    group   => 'quaggavty',
    mode    => '0644',
    content => template('profile/cumulus/Quagga.conf.erb'),
  }

  file { '/etc/quagga/daemons':
    owner  => 'quagga',
    group  => 'quagga',
    source => 'puppet:///modules/profile/cumulus/quagga_daemons',
  }

  service { 'quagga':
    ensure    => running,
    hasstatus => false,
    enable    => true,
    subscribe => [
      File['/etc/quagga/daemons'],
      File['/etc/quagga/Quagga.conf'],
    ]
  }

}
