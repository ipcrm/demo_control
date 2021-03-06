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

    package {'hiera-http':
      ensure   => '1.4.0',
      provider => puppetserver_gem,
    }

    class { '::hiera':
      datadir_manage       => false,
      datadir              => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
      hierarchy            => [
        'nodes/%{clientcert}',
        '%{environment}/%{role}',
        '%{environment}/common',
        '%{location}/%{role}',
        '%{location}/common',
        'role/%{role}',
        'common',
      ],
      eyaml                => true,
      eyaml_extension      => 'yaml',
      eyaml_gpg            => true,
      eyaml_gpg_recipients => 'matthew.cadorette@puppetlabs.com',
      merge_behavior       => 'deeper',
      backends             => ['eyaml','http'],
      backend_options      => {
        'http'              => {
          'host'            => 'jenkins.demo.lan',
          'port'            => '8080',
          'output'          => 'json',
          # lint:ignore:quoted_booleans
          'use_auth'        => 'true',
          # lint:endignore
          'auth_user'       => 'admin',
          'auth_pass'       => 'puppetlabs',
          'cache_timeout'   => 10,
          'failure'         => 'graceful',
          'paths'           => [
            # lint:ignore:double_quoted_strings
            "/hiera/lookup?scope=%{::trusted.certname}&key=%{key}",
            "/hiera/lookup?scope=%{::virtual}&key=%{key}",
            "/hiera/lookup?scope=%{::appenv}&key=%{key}",
            "/hiera/lookup?scope=%{::environment}&key=%{key}",
          ],
          'confine_to_keys' => [
            "rgbank.*",
            "flask_puppet.*",
            # lint:endignore
          ],
        },
      },
    }

    if defined(Service['pe-puppetserver']){

      file{'/etc/puppetlabs/puppet/autosign.conf':
        ensure  => present,
        mode    => '0644',
        owner   => 'pe-puppet',
        group   => 'pe-puppet',
        content => '*',
        notify  => Service['pe-puppetserver'],
      }

    }else{

      file{'/etc/puppetlabs/puppet/autosign.conf':
        ensure  => present,
        mode    => '0644',
        owner   => 'pe-puppet',
        group   => 'pe-puppet',
        content => '*',
      }

    }


    file_line{'require_tty_sudo':
      ensure => 'absent',
      path   => '/etc/sudoers',
      line   => 'Defaults    requiretty',
    }

}
