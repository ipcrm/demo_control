class profile::apps::gitlab {

  #Install gitlab
  file { ['/etc/gitlab', '/etc/gitlab/ssl'] :
    ensure => directory,
  }

  class { '::gitlab':
    external_url => "http://${::fqdn}",
  }

  #Initialize gitlab
  file { '/etc/gitlab/init.sh':
    ensure  => file,
    mode    => '0700',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/profile/gitlab-init.sh',
    require => Class['gitlab'],
  }

  exec { '/etc/gitlab/init.sh && touch /etc/gitlab/init':
    creates => '/etc/gitlab/init',
    require => File['/etc/gitlab/init.sh'],
  }

}
