class profile::master::puppetserver {

    Firewall {
      chain  => 'INPUT',
      proto  => 'tcp',
      action => 'accept',
    }

    firewall { '110 puppetmaster allow all': dport  => '8140';  }
    firewall { '110 orchservices allow all': dport  => '8142';  }
    firewall { '110 orchservice  allow all': dport  => '8143';  }
    firewall { '110 dashboard allow all':    dport  => '443';   }
    firewall { '110 mcollective allow all':  dport  => '61613'; }

    class { 'hiera':
      datadir_manage => false,
      datadir        => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
      hierarchy      => [
        'nodes/%{clientcert}',
        '%{environment}/%{role}',
        '%{environment}/common',
        '%{location}/%{role}',
        '%{location}/common',
        'role/%{role}',
        'common',
      ],
      eyaml          => true,
      merge_behavior => 'deeper',
    }

    file{'/etc/puppetlabs/puppet/autosign.conf':
      ensure  => present,
      mode    => '0644',
      owner   => 'pe-puppet',
      group   => 'pe-puppet',
      content => '*',
      notify  => Service['pe-puppetserver'],
    }

    file_line{'require_tty_sudo':
      ensure => 'absent',
      path   => '/etc/sudoers',
      line   => 'Defaults    requiretty',
    }

}
