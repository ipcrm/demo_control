class profile::base::security::firewall {

  case $::kernel {
    'Windows': {

      class { 'windows_firewall':
        ensure => 'running'
      }

    }

    default: {
      Firewall {
        require => undef,
        notify  => Service['iptables'],
      }

      contain ::firewall

      firewall { '000 accept all icmp':
        proto  => 'icmp',
        action => 'accept',
      }

      firewall { '001 accept all to lo interface':
        proto   => 'all',
        iniface => 'lo',
        action  => 'accept',
      }

      firewall { '002 accept related established rules':
        proto  => 'all',
        state  => ['RELATED', 'ESTABLISHED'],
        action => 'accept',
      }

    }

  }


}
